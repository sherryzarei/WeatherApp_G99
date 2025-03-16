//
//  ViewController.swift
//  WeatherApp_G99
//
//  Created by Shaghayegh zarei on 2025-02-28.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    let networkManager = WeatherNetworkManager()
    var locationManager = CLLocationManager()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!

    // MARK: - UI Elements

    let currentLocation = ViewController.makeLabel(fontSize: 38, weight: .heavy, text: "...Location")
    let currentTime = ViewController.makeLabel(fontSize: 10, weight: .heavy, text: "15 February 2025")
    let currentTemperatureLabel = ViewController.makeLabel(fontSize: 60, weight: .heavy, text: "°C")
    let tempDescription = ViewController.makeLabel(fontSize: 14, weight: .light, text: "...")

    let tempSymbol: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "cloud.fill")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()

    let maxTemp = ViewController.makeLabel(fontSize: 14, weight: .medium, text: "°C")
    let minTemp = ViewController.makeLabel(fontSize: 14, weight: .medium, text: "°C")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundImage()
        transparentNavigationBar()
        setupNavigationBar()
        setupViews()
        layoutViews()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // MARK: - Setup Helpers

    static func makeLabel(fontSize: CGFloat, weight: UIFont.Weight, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return label
    }

    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "beautiful-sunset-sky")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }

    func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(handleAddPlaceButton)),
            UIBarButtonItem(image: UIImage(systemName: "thermometer"), style: .done, target: self, action: #selector(handleShowForecast)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(handleRefresh))
        ]
    }

    func transparentNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setupViews() {
        [currentLocation, currentTemperatureLabel, tempSymbol, tempDescription, currentTime, minTemp, maxTemp].forEach {
            view.addSubview($0)
        }
    }

    // MARK: - Layout Constraints

    func layoutViews() {
        NSLayoutConstraint.activate([
            currentLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            currentLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),

            currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 4),
            currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            currentTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            currentTime.heightAnchor.constraint(equalToConstant: 10),

            currentTemperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            currentTemperatureLabel.widthAnchor.constraint(equalToConstant: 250),

            tempSymbol.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor),
            tempSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            tempSymbol.heightAnchor.constraint(equalToConstant: 50),
            tempSymbol.widthAnchor.constraint(equalToConstant: 50),

            tempDescription.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 12.5),
            tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor, constant: 8),
            tempDescription.widthAnchor.constraint(equalToConstant: 250),
            tempDescription.heightAnchor.constraint(equalToConstant: 20),

            minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: 80),
            minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            minTemp.widthAnchor.constraint(equalToConstant: 100),
            minTemp.heightAnchor.constraint(equalToConstant: 20),

            maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            maxTemp.widthAnchor.constraint(equalToConstant: 100),
            maxTemp.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Location Updates

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil

        let location = locations.first!.coordinate
        latitude = location.latitude
        longitude = location.longitude

        loadDataUsingCoordinates(lat: "\(latitude!)", lon: "\(longitude!)")
    }

    // MARK: - Data Loading

    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { weather in
            self.updateUI(with: weather)
        }
    }

    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { weather in
            self.updateUI(with: weather)
        }
    }

    func updateUI(with weather: WeatherModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))

        DispatchQueue.main.async {
            self.currentTemperatureLabel.text = "\(weather.main.temp.kelvinToCeliusConverter())°C"
            self.currentLocation.text = "\(weather.name ?? ""), \(weather.sys.country ?? "")"
            self.tempDescription.text = weather.weather.first?.description
            self.currentTime.text = stringDate
            self.minTemp.text = "Min: \(weather.main.temp_min.kelvinToCeliusConverter())°C"
            self.maxTemp.text = "Max: \(weather.main.temp_max.kelvinToCeliusConverter())°C"
            self.tempSymbol.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather.first?.icon ?? "01d")@2x.png")
            UserDefaults.standard.set(weather.name ?? "", forKey: "SelectedCity")
        }
    }

    // MARK: - Navigation Actions

    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "City Name" }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let city = alertController.textFields?.first?.text {
                self.loadData(city: city)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    @objc func handleShowForecast() {
        navigationController?.pushViewController(ForecastViewController(), animated: true)
    }

    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
}
