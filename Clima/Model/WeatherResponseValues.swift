//
//  WeatherResponseFormat.swift
//  Clima
//
//  Created by Kyler Saiki on 6/20/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherResponseValues: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
