//
//  Network.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit
import SwiftyJSON

class Network {
    static func loadJSON(
        url: String,
        queue: DispatchQueue? = DispatchQueue.main,
        completion: @escaping (JSON?, NetworkError?) -> ()
    ) {
        let errorHandler = { (error: NetworkError) in
            if let dispatchQueue = queue {
              dispatchQueue.async {
                  completion(nil, error)
              }
            } else {
              completion(nil, error)
            }
        }

        guard let url = URL(string: url) else {
            errorHandler(.badUrlError)
            return
        }

        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                errorHandler(.badRequestError)
                return
            }
            guard httpResponse.statusCode == 200 else {
                errorHandler(.badStatusCodeError(statusCode: httpResponse.statusCode))
                return
            }

            guard let jsonData = data else {
                errorHandler(.noDataError)
                return
            }

            completion(JSON(jsonData), nil)
        }

        onMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        dataTask.resume()
        onMainThread {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
