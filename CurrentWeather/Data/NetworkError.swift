//
//  NetworkError.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 21/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import Foundation

enum NetworkError: Error, Describable {
    case badUrlError
    case badRequestError
    case badStatusCodeError(statusCode: Int)
    case noDataError
    case parseError
    case noApi

    public func getText() -> String {
        let errorText: String
        switch self {
        case .badUrlError:
            errorText = "Incorrect URL"
        case .badRequestError:
            errorText = "Bad Request"
        case .badStatusCodeError(let statusCode):
            errorText = "Request error. Status code \(statusCode)"
        case .noDataError:
            errorText = "No data returned"
        case .parseError:
            errorText = "Parse error"
        case .noApi:
            errorText = "No Api key"
        }
        return errorText
    }
}
