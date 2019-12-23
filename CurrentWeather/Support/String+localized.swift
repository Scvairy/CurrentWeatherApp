//
//  String+localized.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 21/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import Foundation

extension String {

    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "*\(self)*".uppercased(), comment: "")
    }

}
