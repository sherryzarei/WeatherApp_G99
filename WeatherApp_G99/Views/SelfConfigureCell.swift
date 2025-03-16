//
//  SelfConfigureCell.swift
//  WeatherApp_G99
//
//  Created by Shaghayegh zarei on 2025-03-14.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}
