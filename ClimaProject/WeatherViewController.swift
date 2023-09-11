//
//  ViewController.swift
//  ClimaProject
//
//  Created by Mitali Gupta on 06/09/23.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UISearchBar!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
        
    }
}

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        
    }
}
    extension WeatherViewController: WeatherManagerDelegate {
        
        func didUpdateWeather(_weatherManager: WeatherManager, weather: WeatherModel){
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(weather.temperatureString)ºC"
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityname
            }
        }
        func didFailWithError(error: Error) {
            print(error)
        }
    }

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location  = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
