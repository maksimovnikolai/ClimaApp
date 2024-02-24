//
//  WeatherView.swift
//  ClimaApp
//
//  Created by Nikolai Maksimov on 23.02.2024.
//

import UIKit

final class WeatherView: UIView {
    
    // MARK: Properties
    lazy var navigationButton = makeButton("location.circle.fill")
    lazy var searchTextField = makeTextField()
    lazy var searchButton = makeButton("magnifyingglass")
    lazy var cityLabel = makeLabel(title: "City", font: .systemFont(ofSize: 30))
    lazy var tempValueLabel = makeLabel(title: "0", font: .boldSystemFont(ofSize: 80))
    lazy var conditionImageView = makeImageView(UIImage(systemName: "sun.max")!, mode: .scaleAspectFit)
   
    // MARK: Private Properties
    private lazy var tempMinCircleLabel = makeLabel(title: "°", font: .systemFont(ofSize: 100, weight: .light))
    private lazy var tempDegreeLabel = makeLabel(title: "C", font: .systemFont(ofSize: 100, weight: .light))
    private lazy var backgroundImage = makeImageView(#imageLiteral(resourceName: "background"), mode: .scaleAspectFill)
    private lazy var searchStackView = setupSearchHStack()
    private lazy var tempStackView = setupTempHStack()
    private lazy var mainStackView = configureMainVStack()
    private lazy var customView = makeView()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods
extension WeatherView {
    
    private func commonInit() {
        setupImageConstraints()
        setupParam()
        setupMainStackConstraints()
    }
}

// MARK: - Stack Configuration
extension WeatherView {
    
    private func setupSearchHStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        [navigationButton, searchTextField, searchButton].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }
    
    private func setupTempHStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        [tempValueLabel, tempMinCircleLabel, tempDegreeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }
    
    private func configureMainVStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.distribution = .fill
        stackView.spacing = 10
        [searchStackView, conditionImageView, tempStackView, cityLabel, customView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }
}

// MARK: - UI Elements
extension WeatherView {
    
    private func makeImageView(_ image: UIImage, mode: UIView.ContentMode) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = mode
        imageView.tintColor = UIColor(named: "weatherColor")
        return imageView
    }
    
    private func makeTextField() -> UITextField {
        let tf = UITextField()
        tf.placeholder = "Search"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemFill
        tf.textAlignment = .right
        tf.autocapitalizationType = .words
        tf.returnKeyType = .go
        return tf
    }
    
    private func makeButton(_ sfS: String) -> UIButton {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: sfS)
        button.tintColor = .label
        return button
    }
    
    private func makeLabel(title: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = font
        return label
    }
    
    private func makeView() -> UIView {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }
}

// MARK: - Constraints
extension WeatherView {
    
    private func setupImageConstraints() {
        addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupMainStackConstraints() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupParam() {
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        conditionImageView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationButton.widthAnchor.constraint(equalToConstant: 40),
            navigationButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            searchStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            searchStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            conditionImageView.widthAnchor.constraint(equalToConstant: 120),
            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
        ])
        searchTextField.setContentHuggingPriority(.init(249), for: .horizontal)
        tempValueLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        cityLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        cityLabel.setContentHuggingPriority(.init(251), for: .vertical)
    }
}
