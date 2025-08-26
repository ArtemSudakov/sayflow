//
//  HomeViewModel.swift
//  SayFlow
//
//  Created by Asd on 26.08.2025.
//

import SwiftUI

final class HomeViewModel: HomeViewModelProtocol {
    private weak var router: ViewsRouter?
    private let helper: Helper
    private var fromLangCode = "auto"
    private var toLangCode = "en"
    
    @Published var inputText: String = ""
    @Published var outText: String = ""
    @Published var fromLangLabel: String = ""
    @Published var toLangLabel: String = ""
    
    init(router: ViewsRouter) {
        self.router = router
        self.helper = Helper()
        
        let currentLocale = self.helper.currentSystemLanguageCode()
        self.fromLangCode = self.helper.languageDisplayName(for: "auto")
        self.toLangCode = self.helper.languageDisplayName(for: currentLocale)
        self.fromLangLabel = self.helper.languageDisplayName(for: self.fromLangCode)
        self.toLangLabel = self.helper.languageDisplayName(for: self.toLangCode)
        
    }
    
    func recordingStart() {
        print("Start recording")
    }
    
    func recordingStop() {
        print("Stop recording")
    }
    
    func swapLangs() {
        print("Swap lang")
    }
    
    func openCamera() {
        print("openCamera")
    }
    func openGellary() {
        print("openGellary")
    }
    func openSettings() {
        print("openSettings")
    }
    func openHistory() {
        print("openHistory")
    }
    func fromLangSelectOpen() {
        print("fromLangSelectOpen")
    }
    func toLangSelectOpen() {
        print("toLangSelectOpen")
    }
    func clearTranslateText() {print("clearTranslateText")}
    func saveToHistory() {print("saveToHistory")}
    func copyFromText() {print("copyFromText")}
    func copyToText() {print("copyToText")}
    func pasteFromClipboard() {print("pasteFromClipboard")}
}
