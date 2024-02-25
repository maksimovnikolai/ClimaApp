//
//  WeatherViewController.swift
//  ClimaApp
//
//  Created by Nikolai Maksimov on 23.02.2024.
//


import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    // MARK: Private Properties
    private let weatherView = WeatherView()
    private let locationManager = CLLocationManager()
    
    // MARK: Life Cycle
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

// MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        weatherView.searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let city = textField.text else { return }
        fetchWeather(cityName: city)
        weatherView.searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if weatherView.searchTextField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter the city name"
            return false
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    // определение местоположения
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            WeatherManager.shared.fetchWeather(latitude: lat, longitude: lon) { result in
                switch result {
                case .success(let weather):
                    self.weatherView.tempValueLabel.text = weather.temperatureString
                    self.weatherView.conditionImageView.image = UIImage(systemName: weather.conditionName)
                    self.weatherView.cityLabel.text = weather.cityName
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: Private Methods
extension WeatherViewController {
    
    private func commonInit() {
        configureCoreLocation()
        addTarget()
        fetchWeather(cityName: "Moscow")
    }
    
    private func configureCoreLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    private func addTarget() {
        weatherView.searchTextField.delegate = self
        weatherView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        weatherView.navigationButton.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
    }
    
    @objc
    private func searchButtonTapped() {
        weatherView.searchTextField.endEditing(true)
    }
    
    @objc
    private func locationPressed() {
        
    }
    
    
    private func fetchWeather(cityName: String) {
        WeatherManager.shared.fetchWeather(cityName: cityName) { result in
            switch result {
                
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weatherView.tempValueLabel.text = weather.temperatureString
                    self.weatherView.conditionImageView.image = UIImage(systemName: weather.conditionName)
                    self.weatherView.cityLabel.text = weather.cityName
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
