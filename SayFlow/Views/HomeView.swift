//
//  HomeView.swift
//  sayflow
//
//  Created by Asd on 16.08.2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: ViewsRouter
    
    @State private var inputText: String = ""
    @State private var outText: String = ""
    @State private var keyboardShown = false
    
    @State private var from = "auto"
    @State private var to   = "ukrainian"
    
    // mic btn 2 event types logic
    @State private var recording = false
    @State private var suppressNextTap = false
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                    }) {
                        Image(systemName: "timer")
                            .font(.title3)
                            .foregroundColor(Color("Gray44"))
                            .bold()
                    }
                    Spacer()
                    Text("translate".localized)
                        .fontWeight(.ultraLight)
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title3)
                            .foregroundColor(Color("Gray44"))
                    }
                }
                .padding()
                
                AutoGrowShrinkTextEditor(
                    text: $inputText,
                    placeholder: "enter_text_placeholder".localized,
                    minHeight: 50,
                    maxHeight: 150,
                    fontRange: 18...28,
                    weight: .bold,
                    isEditable: true,
                    shrinkExponent: 2
                )
                .fadingEdges([.top, .bottom], length: 10)
                AutoGrowShrinkTextEditor(
                    text: $outText,
                    placeholder: "",
                    minHeight: 50,
                    maxHeight: 150,
                    fontRange: 18...28,
                    weight: .bold,
                    isEditable: false,
                    isSelectable: true,
                    autoScrollToBottomOnChange: true,
                    shrinkExponent: 2
                )
                .fadingEdges([.top, .bottom], length: 10)
                
                Spacer()
            }
            .padding(.bottom)
            .background(
                RoundedCorner(radius: 32, corners: [.bottomLeft, .bottomRight])
                    .fill(.white)
            )
            .keyboardVisibility($keyboardShown)
            .animation(.easeInOut(duration: 0.2), value: keyboardShown)
            
            VStack {
                HStack(spacing: 12) {
                    Button {
                        router.push(.langSelect)
                    } label: {
                        Text(from)
                            .frame(width: 150, height: 44)
                            .background(Color.white)
                            .cornerRadius(12)
                            .foregroundStyle(Color("Gray44"))
                    }
                    
                    Button {
                        swap(&from, &to)
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                            .foregroundStyle(Color("Gray44"))
                            .bold()
                    }
                    
                    Button {
                        
                    } label: {
                        Text(to)
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
                
            }
            
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
                        
                            // если только что был long-press — игнорим ближайший tap
                            if suppressNextTap {
                                suppressNextTap = false
                                return
                            }
                            // tap = toggle запись
                            recording.toggle()
                            print(recording ? "tap: start" : "tap: stop")
                            // TODO: вызов старта/стопа записи
                        
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
                        // поведение "пока держу — пишет; отпустил — стоп"
                        pressing: { isPressing in
                            if isPressing {
                                suppressNextTap = true // подавим последующий tap
                                if !recording {
                                    recording = true
                                    print("hold: start")
                                    // TODO: start recording (hold)
                                }
                            } else {
                                if recording {
                                    recording = false
                                    print("hold: stop")
                                    // TODO: stop recording (hold)
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
                .padding(.top, -18)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
        }.background(Color(white: 0.5, opacity: 0.1), ignoresSafeAreaEdges: Edge.Set.bottom)
    }
}

#Preview {
    HomeView()
}
