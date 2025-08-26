//
//  HomeView.swift
//  sayflow
//
//  Created by Asd on 16.08.2025.
//

import SwiftUI

protocol HomeViewModelProtocol: ObservableObject {
    var inputText: String { get set }
    var outText: String { get set }
    var fromLangLabel: String { get }
    var toLangLabel: String { get }
    
    func recordingStart()
    func recordingStop()
    func swapLangs()
    func openCamera()
    func openGellary()
    func openSettings()
    func openHistory()
    func fromLangSelectOpen()
    func toLangSelectOpen()
    func clearTranslateText()
    func saveToHistory()
    func copyFromText()
    func copyToText()
    func pasteFromClipboard()
}

struct HomeView<VM: HomeViewModelProtocol>: View {
    @ObservedObject var vm: VM
    @State private var keyboardShown = false
    
    // mic btn 2 event types logic
    @State private var recording = false
    @State private var suppressNextTap = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    if (vm.inputText.isEmpty) {
                        Button(action: {
                            vm.openHistory()
                        }) {
                            Image(systemName: "timer")
                                .font(.title3)
                                .foregroundColor(Color("Gray44"))
                                .fontWeight(.bold)
                                .frame(width: 24, height: 24)
                        }
                        .id("historyBtn")
                        .transition(.scale.combined(with: .opacity))
                    }
                    else {
                        Button(action: {
                            vm.saveToHistory()
                        }) {
                            Image(
                                systemName: "square.and.arrow.down.badge.clock"
                            )
                            .font(.title3)
                            .foregroundColor(Color("Gray44"))
                            .frame(width: 24, height: 24)
                        }
                        .id("settingsBtn")
                        .transition(.scale.combined(with: .opacity))
                    }
                    Spacer()
                    Text("translate".localized)
                        .fontWeight(.ultraLight)
                        .font(.title2)
                    Spacer()
                    if (vm.inputText.isEmpty) {
                        Button(action: {
                            vm.openSettings()
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title3)
                                .foregroundColor(Color("Gray44"))
                                .frame(width: 24, height: 24)
                        }
                        .id("saveHistoryBtn")
                        .transition(.scale.combined(with: .opacity))
                    }
                    else {
                        Button(action: {
                            vm.clearTranslateText()
                        }) {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .foregroundColor(Color("Gray44"))
                                .frame(width: 24, height: 24)
                        }
                        .id("cleanInputArea")
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding()
                .padding(.top, -16)
                .animation(.easeInOut, value: vm.inputText.isEmpty)
                
                ZStack {
                    AutoGrowShrinkTextEditor(
                        text: $vm.inputText,
                        placeholder: "enter_text_placeholder".localized,
                        minHeight: 50,
                        maxHeight: 150,
                        fontRange: 18...28,
                        weight: .bold,
                        isEditable: true
                    )
                    .fadingEdges([.top], length: 10)
                    .focused($isFocused)
                    VStack {
                        if vm.inputText.isEmpty {
                            HStack {
                                Spacer()
                                Button {
                                    vm.pasteFromClipboard()
                                } label: {
                                    HStack {
                                        Text("paste".localized)
                                            .foregroundColor(Color("Gray44"))
                                            .fontWeight(.light)
                                        Image(systemName: "return.left")
                                            .font(.title3)
                                            .foregroundColor(Color("Gray44"))
                                    }
                                    .id("insertFromClipboard")
                                    .transition(.scale.combined(with: .opacity))
                                }
                                
                            }
                            .padding()
                            .padding(.top, 4)
                        }
                    }.animation(.easeInOut, value: vm.inputText.isEmpty)
                }
                .padding(.horizontal)
                .padding(.top, -8)
                
                VStack {
                    if (!vm.inputText.isEmpty) {
                        HStack {
                            Spacer()
                            Button {
                                vm.copyFromText()
                            } label: {
                                HStack {
                                    
                                    Text("copy".localized)
                                        .foregroundColor(Color("Gray44"))
                                        .fontWeight(.light)
                                        .font(.subheadline)
                                    
                                    Image(
                                        systemName: "document.on.document.fill"
                                    )
                                    .font(.subheadline)
                                    .foregroundColor(Color("Gray44"))
                                    .symbolRenderingMode(.hierarchical)
                                    
                                }.padding(.top, -4)
                                
                            }
                            .opacity(vm.inputText.isEmpty ? 0 : 1)
                            .disabled(vm.inputText.isEmpty)
                            
                        }.padding(.horizontal)
                        
                    }
                }.animation(.easeInOut, value: vm.inputText.isEmpty)
                
                VStack {
                    if (vm.inputText.isEmpty && !keyboardShown) {
                        VStack {
                            Spacer()
                            Text("tap_to_start".localized)
                                .font(.title3)
                                .foregroundColor(Color("Gray44").opacity(0.2))
                                .fontWeight(.bold)
                            Spacer()
                        }.opacity(keyboardShown ? 0 : 1)
                    }
                }.animation(.easeInOut, value: keyboardShown)
                
                AutoGrowShrinkTextEditor(
                    text: $vm.inputText,
                    placeholder: "",
                    minHeight: 50,
                    maxHeight: 150,
                    fontRange: 18...28,
                    weight: .bold,
                    isEditable: false,
                    isSelectable: true,
                    autoScrollToBottomOnChange: true
                )
                .fadingEdges([.top], length: 10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                VStack {
                    if (!vm.inputText.isEmpty) {
                        HStack {
                            Spacer()
                            Button {
                                vm.copyToText()
                            } label: {
                                HStack {
                                    Text("copy".localized)
                                        .font(.subheadline)
                                        .foregroundColor(Color("Gray44"))
                                        .fontWeight(.light)
                                    
                                    Image(
                                        systemName: "document.on.document.fill"
                                    )
                                    .font(.subheadline)
                                    .foregroundColor(Color("Gray44"))
                                    .symbolRenderingMode(.hierarchical)
                                    
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        .opacity(vm.inputText.isEmpty ? 0 : 1)
                        .disabled(vm.inputText.isEmpty)
                        .padding(.top, -4)
                    }
                }.animation(.easeInOut, value: vm.inputText.isEmpty)
                
                Spacer()
            }
            .background(
                RoundedCorner(
                    radius: 32,
                    corners: [.bottomLeft, .bottomRight]
                )
                .fill(.white)
            )
            .keyboardVisibility($keyboardShown)
            .animation(.easeInOut(duration: 0.2), value: keyboardShown)
            .onTapGesture {
                isFocused = true
            }
        
            VStack {
                HStack(spacing: 12) {
                    Button {
                        vm.fromLangSelectOpen()
                    } label: {
                        Text(vm.fromLangLabel)
                            .frame(width: 150, height: 44)
                            .background(Color.white)
                            .cornerRadius(12)
                            .foregroundStyle(Color("Gray44"))
                    }
                    
                    Button {
                        vm.swapLangs()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                            .foregroundStyle(Color("Gray44"))
                            .bold()
                    }
                    
                    Button {
                        vm.toLangSelectOpen()
                    } label: {
                        Text(vm.toLangLabel)
                            .frame(width: 150, height: 44)
                            .background(Color.white)
                            .cornerRadius(12)
                            .foregroundStyle(Color("Gray44"))
                    }
                }
                .controlSize(.large)
                .font(.body.weight(.medium))
                .padding(.horizontal)
                .padding(.vertical)
                .padding(.top, -8)
                
            }.padding(.top, 8)
            
            if !keyboardShown {
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "photo.badge.magnifyingglass")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("Gray44"))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Circle())
                            .padding(.top)
                    }
                    Spacer()
                    Button {
                        // ignore after long press
                        if suppressNextTap {
                            suppressNextTap = false
                            return
                        }
                        // tap = toggle record
                        recording.toggle()
                    
                        if (recording) {
                            vm.recordingStart()
                        }
                        else {
                            vm.recordingStop()
                        }
                    } label: {
                        Image(systemName: recording ? "stop.fill" : "mic")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color("Gray44"))
                    }.buttonStyle(PulsingButtonStyle(
                        shape: .circle(size: 90),
                        fill: Color.gray.opacity(0.25),
                        ringColor: Color.gray.opacity(0.5),
                        ringLineWidth: 3,
                        ringScale: 1.6,
                        ringCount: 2,
                        duration: 2.4,
                        isActive: recording,
                        alsoPulseWhilePressed: true
                    ))
                    .onLongPressGesture(
                        minimumDuration: 0.25,
                        maximumDistance: 50,
                        pressing: { isPressing in
                            if isPressing {
                                suppressNextTap = true // подавим последующий tap
                                if !recording {
                                    recording = true
                                    vm.recordingStart()
                                }
                            } else {
                                if recording {
                                    recording = false
                                    vm.recordingStop()
                                }
                            }
                        },
                        perform: { }
                    )
                    .padding(.top)
                    
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color("Gray44"))
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Circle())
                            .padding(.top)
                    }
                    Spacer()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
        }.background(
            Color(white: 0.5, opacity: 0.1),
            ignoresSafeAreaEdges: Edge.Set.bottom
        )
    }
}
