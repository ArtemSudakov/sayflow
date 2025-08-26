//
//  Helper.swift
//  SayFlow
//
//  Created by Asd on 26.08.2025.
//
import SwiftUI

struct Helper {
    func languageDisplayName(for code: String, in locale: Locale = .current) -> String {
        if code == "auto" {
            return "auto".localized
        }
        return locale
            .localizedString(forLanguageCode: code)?.capitalized ?? code
    }
        
    func currentSystemLanguageCode() -> String {
        let lang = Locale.preferredLanguages.first ?? "en-US"
        return String(lang.prefix(2))
    }
}
