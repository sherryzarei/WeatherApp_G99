//
//  ForcastViewController.swift
//  WeatherApp_G99
//
//  Created by Ali Mousavi Roozbahani  on 2025-02-28.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    
    struct Forecast {
        let day: String
        let data: [(time: String, icon: String, temperature: String)]
    }
    
    let forecastData: [Forecast] = [
        Forecast(day: "Saturday", data: [("18:00", "cloud.fog", "7.8°C"), ("21:00", "cloud.fog", "10.3°C")]),
        Forecast(day: "Sunday", data: [("00:00", "cloud.fog", "12.5°C"), ("03:00", "cloud.fog", "11.2°C"), ("06:00", "cloud.fog", "10.7°C"), ("09:00", "cloud.fog", "10.4°C")]),
        Forecast(day: "Monday", data: [("00:00", "cloud.fog", "11.7°C"), ("03:00", "cloud.fog", "11.4°C"), ("06:00", "cloud.fog", "10.6°C"), ("09:00", "cloud.fog", "9.8°C")]),
        Forecast(day: "Tuesday", data: [("00:00", "cloud.fog", "12.4°C"), ("03:00", "cloud.fog", "10.5°C"), ("06:00", "cloud.fog", "9.8°C"), ("09:00", "cloud.drizzle", "9.3°C")]),
        Forecast(day: "Wednesday", data: [("00:00", "cloud.fog", "12.9°C"), ("03:00", "cloud.fog", "11.3°C"), ("06:00", "cloud.fog", "10.9°C"), ("09:00", "cloud.rain", "11.0°C")]),
        Forecast(day: "Thursday", data: [("00:00", "sun.haze", "11.1°C"), ("03:00", "cloud.fog", "10.7°C"), ("06:00", "cloud.fog", "9.8°C"), ("09:00", "sun.max", "9.0°C")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Forecast"
        view.backgroundColor = .white
        setupTableView()
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ForecastCell.self, forCellReuseIdentifier: "ForecastCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData[section].data.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return forecastData[section].day
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastCell
        let forecast = forecastData[indexPath.section].data[indexPath.row]
        cell.configure(time: forecast.time, icon: forecast.icon, temperature: forecast.temperature)
        return cell
    }
}

// Custom Cell
class ForecastCell: UITableViewCell {
    
    let timeLabel = UILabel()
    let iconImageView = UIImageView()
    let temperatureLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        timeLabel.font = .systemFont(ofSize: 16)
        temperatureLabel.font = .systemFont(ofSize: 16)
        
        iconImageView.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, temperatureLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(time: String, icon: String, temperature: String) {
        timeLabel.text = time
        iconImageView.image = UIImage(systemName: icon)
        temperatureLabel.text = temperature
    }
}
