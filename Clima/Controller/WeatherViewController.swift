//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var weatherResponse = WeatherResponse()
    var toggleMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegates
        weatherResponse.delegate = self
        searchTextField.delegate = self
    }
    
    //Toggle Between Light and Dark Mode on toggle button press
    @IBAction func toggleMode(_ sender: UIButton) {
        if (toggleMode == false) {
            toggleMode = true
            toggleButton.setBackgroundImage(UIImage(systemName: "sun.max"), for: .normal)
            toggleButton.tintColor = UIColor.black
            searchButton.tintColor = UIColor.black
            cityLabel.textColor = UIColor.black
            temperatureLabel.textColor = UIColor.black
            degreesLabel.textColor = UIColor.black
            unitsLabel.textColor = UIColor.black
            conditionImageView.tintColor = UIColor(red: 0.104, green: 0.299, blue: 0.324, alpha: 1.0)
            backgroundImage.image = UIImage(named: "light-background")
            
        } else {
            toggleMode = false
            toggleButton.setBackgroundImage(UIImage(systemName: "moon"), for: .normal)
            toggleButton.tintColor = UIColor.white
            searchButton.tintColor = UIColor.white
            cityLabel.textColor = UIColor.white
            temperatureLabel.textColor = UIColor.white
            conditionImageView.tintColor = UIColor.white
            degreesLabel.textColor = UIColor.white
            unitsLabel.textColor = UIColor.white
            backgroundImage.image = UIImage(named: "dark-background")
        }
    }
    
}

//Text Field Delegate
extension WeatherViewController: UITextFieldDelegate {
    
    //End typing when the search button is pressed
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    //Stop editing the texzt field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    //Check if text in text field
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a city or US zip code"
            return false
        }
    }
    
    //Send Request if there is text
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            if (Int(city) == nil) {
                weatherResponse.fetchWeather(cityName: city)
            } else {
                weatherResponse.fetchWeatherZip(zipCode: Int(city)!)
            }
            weatherResponse.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//Weather Response Delegate
extension WeatherViewController: WeatherResponseDelegate {
    
    //update the UI with the response
    func didUpdateWeather(_ weatherResponse: WeatherResponse, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionImage)
            self.cityLabel.text = weather.cityName
        }
    }
    
    //print error if failed request
    func didFailWithError(error: Error) {
        print(error)
    }
}
