//
//  ViewController.swift
//  WeatherApp_G99
//
//  Created by Shaghayegh zarei on 2025-02-28.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let networkManager = WeatherNetworkManager()
    private let locationManager = CLLocationManager()
    
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    // MARK: - UI Components
    private lazy var currentLocation = createLabel(fontSize: 38, weight: .heavy, text: "...Location")
    private lazy var currentTime = createLabel(fontSize: 10, weight: .heavy, text: "15 February 2025")
    private lazy var currentTemperatureLabel = createLabel(fontSize: 60, weight: .heavy, text: "°C")
    private lazy var tempDescription = createLabel(fontSize: 14, weight: .light, text: "...")
    private lazy var minTemp = createLabel(fontSize: 14, weight: .medium, text: "  °C")
    private lazy var maxTemp = createLabel(fontSize: 14, weight: .medium, text: "  °C")
    
    private let tempSymbol: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupNavigation()
        setupLocation()
        setupUI()
        layoutUI()
    }
}

// MARK: - Setup Methods
private extension ViewController {
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "cloudy-day")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    func setupNavigation() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)),
            UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handleShowForecast)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        ]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupUI() {
        [currentLocation, currentTime, currentTemperatureLabel, tempSymbol,
         tempDescription, minTemp, maxTemp].forEach(view.addSubview)
    }
    
    func layoutUI() {
        NSLayoutConstraint.activate([
            currentLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            currentLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            currentLocation.heightAnchor.constraint(equalToConstant: 70),
            
            currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 4),
            currentTime.leadingAnchor.constraint(equalTo: currentLocation.leadingAnchor),
            currentTime.trailingAnchor.constraint(equalTo: currentLocation.trailingAnchor),
            currentTime.heightAnchor.constraint(equalToConstant: 10),
            
            currentTemperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: currentLocation.leadingAnchor),
            currentTemperatureLabel.widthAnchor.constraint(equalToConstant: 250),
            currentTemperatureLabel.heightAnchor.constraint(equalToConstant: 70),
            
            tempSymbol.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor),
            tempSymbol.leadingAnchor.constraint(equalTo: currentLocation.leadingAnchor),
            tempSymbol.widthAnchor.constraint(equalToConstant: 50),
            tempSymbol.heightAnchor.constraint(equalToConstant: 50),
            
            tempDescription.centerYAnchor.constraint(equalTo: tempSymbol.centerYAnchor),
            tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor, constant: 8),
            tempDescription.widthAnchor.constraint(equalToConstant: 250),
            tempDescription.heightAnchor.constraint(equalToConstant: 20),
            
            minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: 80),
            minTemp.leadingAnchor.constraint(equalTo: currentLocation.leadingAnchor),
            minTemp.widthAnchor.constraint(equalToConstant: 100),
            minTemp.heightAnchor.constraint(equalToConstant: 20),
            
            maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: currentLocation.leadingAnchor),
            maxTemp.widthAnchor.constraint(equalToConstant: 100),
            maxTemp.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    func createLabel(fontSize: CGFloat, weight: UIFont.Weight, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return label
    }
    
    func updateUI(with weather: WeatherModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
        
        currentTemperatureLabel.text = "\(weather.main.temp.kelvinToCeliusConverter())°C"
        currentLocation.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
        tempDescription.text = weather.weather.first?.description
        currentTime.text = stringDate
        minTemp.text = "Min: \(weather.main.temp_min.kelvinToCeliusConverter())°C"
        maxTemp.text = "Max: \(weather.main.temp_max.kelvinToCeliusConverter())°C"
        tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
        
        UserDefaults.standard.set(weather.name ?? "", forKey: "SelectedCity")
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let location = locations.first?.coordinate else { return }
        self.latitude = location.latitude
        self.longitude = location.longitude
        loadDataUsingCoordinates(lat: "\(latitude!)", lon: "\(longitude!)")
    }
}

// MARK: - Network Calls
private extension ViewController {
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { [weak self] weather in
            DispatchQueue.main.async {
                self?.updateUI(with: weather)
            }
        }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { [weak self] weather in
            DispatchQueue.main.async {
                self?.updateUI(with: weather)
            }
        }
    }
}

// MARK: - Button Handlers
private extension ViewController {
    
    @objc func handleAddPlaceButton() {
        let alert = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "City Name" }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let city = alert.textFields?.first?.text {
                self.loadData(city: city)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        [addAction, cancelAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    @objc func handleShowForecast() {
        navigationController?.pushViewController(ForecastViewController(), animated: true)
    }
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
}
