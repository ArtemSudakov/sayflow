//
//  StringLocalization.swift
//  sayflow
//
//  Created by Asd on 16.08.2025.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
