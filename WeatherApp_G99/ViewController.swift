//
//  ViewController.swift
//  WeatherApp_G99
//
//  Created by Shaghayegh zarei on 2025-02-28.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var currentLocation = createLabel(text: "Toronto, Canada", fontSize: 38, weight: .heavy)
    lazy var currentTime = createLabel(text: "15 February 2025", fontSize: 10, weight: .heavy)
    lazy var currentTemperatureLabel = createLabel(text: "5°C", fontSize: 60, weight: .heavy)
    lazy var tempDescription = createLabel(text: "Partly Cloudy", fontSize: 14, weight: .light)
    lazy var maxTemp = createLabel(text: "Max: 8°C", fontSize: 14, weight: .medium)
    lazy var minTemp = createLabel(text: "Min: 2°C", fontSize: 14, weight: .medium)
    
    lazy var tempSymbol: UIImageView = {
        let img = UIImageView(image: UIImage(systemName: "cloud.fill"))
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .gray
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        setupNavigationBar()
        setupViews()
        layoutViews()
    }
    
    func createLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        return label
    }
    
    func setBackgroundImage() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "cloudy-day")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItems = [
            createBarButton(icon: "plus.circle", selector: #selector(handleAddPlaceButton)),
            createBarButton(icon: "thermometer", selector: #selector(handleShowForecast)),
            createBarButton(icon: "arrow.clockwise", selector: #selector(handleRefresh))
        ]
    }
    
    func createBarButton(icon: String, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: icon), style: .done, target: self, action: selector)
    }
    
    func setupViews() {
        [currentLocation, currentTime, currentTemperatureLabel, tempSymbol, tempDescription, minTemp, maxTemp].forEach { view.addSubview($0) }
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            currentLocation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            currentLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            currentLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            currentTime.topAnchor.constraint(equalTo: currentLocation.bottomAnchor, constant: 4),
            currentTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            currentTemperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            tempSymbol.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor),
            tempSymbol.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            tempSymbol.heightAnchor.constraint(equalToConstant: 50),
            tempSymbol.widthAnchor.constraint(equalToConstant: 50),
            
            tempDescription.topAnchor.constraint(equalTo: currentTemperatureLabel.bottomAnchor, constant: 12.5),
            tempDescription.leadingAnchor.constraint(equalTo: tempSymbol.trailingAnchor, constant: 8),
            
            minTemp.topAnchor.constraint(equalTo: tempSymbol.bottomAnchor, constant: 80),
            minTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            
            maxTemp.topAnchor.constraint(equalTo: minTemp.bottomAnchor),
            maxTemp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18)
        ])
    }
    
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: nil, preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "City Name" }
        
        alertController.addAction(UIAlertAction(title: "Add", style: .default))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(alertController, animated: true)
    }
    
    @objc func handleShowForecast() {
        self.navigationController?.pushViewController(ForecastViewController(), animated: true)
    }
    
    @objc func handleRefresh() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        blurView.alpha = 0.0
        view.addSubview(blurView)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 0.8
            blurView.alpha = 1.0
        }) { _ in
            self.view.subviews.forEach { $0.removeFromSuperview() }
            self.setBackgroundImage()
            self.setupViews()
            self.layoutViews()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.alpha = 1.0
                blurView.alpha = 0.0
            }) { _ in
                blurView.removeFromSuperview()
            }
        }
    }
}
