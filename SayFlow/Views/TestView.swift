//import MLKit
//import MLKitTranslate
//import SwiftUI
//
//struct TestView: View {
//    @State private var detectedLang = "…"
//    @State private var translated = "translate will be here ... "
//
//    var body: some View {
//        VStack {
//            Text(detectedLang)
//            Text("After id text")
//            Text(translated)
//        }
//        .task {
//            if let lang = await detectLang("Hello world") {
//                let targetLang = TranslateLanguage(rawValue: "uk")
//                let fromLang = TranslateLanguage(rawValue: lang)
//                translated = await translate("Hello world", from: fromLang, to: targetLang) ?? "cant translate"
//            }
//        }
//    }
//
//    func detectLang(_ text: String) async -> String? {
//        await withCheckedContinuation { (continuation: CheckedContinuation<String?, Never>) in
//            let languageId = LanguageIdentification.languageIdentification()
//            languageId.identifyLanguage(for: text) { languageCode, error in
//                if let code = languageCode, code != "und" {
//                    continuation.resume(returning: code)
//                } else {
//                    continuation.resume(returning: nil)
//                }
//            }
//        }
//    }
//
//    func translate(
//        _ text: String,
//        from source: TranslateLanguage,
//        to target: TranslateLanguage
//    ) async -> String? {
//        await withCheckedContinuation { (continuation: CheckedContinuation<String?, Never>) in
//            
//            let options = TranslatorOptions(sourceLanguage: source, targetLanguage: target)
//            let translator = Translator.translator(options: options)
//            let conditions = ModelDownloadConditions(allowsCellularAccess: true, allowsBackgroundDownloading: true)
//
//            translator.downloadModelIfNeeded(with: conditions) { error in
//                guard error == nil else {
//                    continuation.resume(returning: nil)
//                    return
//                }
//                translator.translate(text) { translatedText, error in
//                    continuation.resume(returning: translatedText)
//                }
//            }
//        }
//    }
//
//}
