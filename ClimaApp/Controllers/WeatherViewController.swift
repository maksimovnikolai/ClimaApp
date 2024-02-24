//
//  WeatherViewController.swift
//  ClimaApp
//
//  Created by Nikolai Maksimov on 23.02.2024.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: Private Properties
    private let weatherView = WeatherView()
    
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

// MARK: Private Methods
extension WeatherViewController {
    
    private func commonInit() {
        addTarget()
        fetchWeather(cityName: "Moscow")
    }
    
    private func addTarget() {
        weatherView.searchTextField.delegate = self
        weatherView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func searchButtonTapped() {
        print("button was tapped")
        weatherView.searchTextField.endEditing(true)
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
