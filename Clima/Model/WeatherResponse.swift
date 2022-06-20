//
//  WeatherResponse.swift
//  Clima
//
//  Created by Kyler Saiki on 6/20/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherResponseDelegate {
    func didUpdateWeather(_ weatherResponse: WeatherResponse, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherResponse {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1fe7bdd03702863faab10822ee37ffa4&units=imperial"
    var delegate: WeatherResponseDelegate?
    
    //search weather by City
    func fetchWeather(cityName: String) {
        let searchURL = "\(weatherURL)&q=\(cityName)"
        performRequest(with: searchURL)
    }
    
    //search weather by Zip Code
    func fetchWeatherZip(zipCode: Int) {
        let searchURL = "\(weatherURL)&zip=\(zipCode),1"
        performRequest(with: searchURL)
    }
    
    func performRequest(with searchURL: String) {
        //send JSON request to openweathermap
        if let url = URL(string: searchURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                //request is failure
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //request is success
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    //parse the JSON response
    func parseJSON(_ weatherResponseValues: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        //set values based on JSON response
        do {
            let decodedData = try decoder.decode(WeatherResponseValues.self, from: weatherResponseValues)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


