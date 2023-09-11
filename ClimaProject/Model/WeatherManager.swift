//
//  WeatherManager.swift
//  ClimaProject
//
//  Created by Mitali Gupta on 07/09/23.
//
import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
struct  WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=dfda571e534bb3ffb73fae8ea1183ac4&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        //create a URL
        if let url = URL(string: urlString){
            
            // Create a url session
            let session = URLSession(configuration: .default)
            
            // Give the session a task
            let task = session.dataTask(with: url){ (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    debugPrint("error!")
                }
                if let safeData = data {
                    if let weather = self.parseJson(weatherData: safeData){
                        self.delegate?.didUpdateWeather( _weatherManager: self, weather: weather)
                    }
                }
            }
            // start the task
            task.resume()
        }
    }
    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityname: name, temperature: temp)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
                         
 
