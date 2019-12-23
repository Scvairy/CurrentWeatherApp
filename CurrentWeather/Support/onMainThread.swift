//
//  onMainThread.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 21/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import Foundation

func onMainThread(execute closure: () -> Void) {
    if Thread.isMainThread {
        closure()
    } else {
        DispatchQueue.main.sync(execute: closure)
    }
}
