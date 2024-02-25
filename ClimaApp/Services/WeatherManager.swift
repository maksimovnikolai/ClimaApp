//
//  WeatherManager.swift
//  ClimaApp
//
//  Created by Nikolai Maksimov on 24.02.2024.
//

import Foundation
import CoreLocation

// MARK: - Network Error
enum NetworkError: Error {
    case invalidURL
    case decodingError
    case noData
}

// MARK: - Weather Manager
final class WeatherManager {
    
    static let shared = WeatherManager()
    private init() {}
    
    // MARK: Fetch Weather
    func fetchWeather(cityName: String, completion: @escaping (Result<WeatherModel, NetworkError>) -> Void) {

        guard let urlString = URL(string: "\(API.weatherURL)?appid=\(API.key)&units=metric&q=\(cityName)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let weather = try self.parseJSON(weatherData: data)
                completion(.success(weather))
            } catch {
                completion(.failure(.noData))
            }
        }.resume()
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherModel, NetworkError>) -> Void) {
        
        guard let urlString = URL(string: "\(API.weatherURL)?appid=\(API.key)&units=metric&lat=\(latitude)&lon\(longitude)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let weather = try self.parseJSON(weatherData: data)
                completion(.success(weather))
            } catch {
                completion(.failure(.noData))
            }
        }.resume()
    }

    
    
    // MARK: Papse JSON
    private func parseJSON(weatherData: Data) throws -> WeatherModel {
        guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: weatherData) else {
            throw NetworkError.decodingError
        }
        let id = decodedData.weather[0].id
        let temp = decodedData.main.temp
        let name = decodedData.name
        
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        return weather
    }
}
