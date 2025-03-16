//
//  asCelsiusFromKelvin.swift
//  WeatherApp_G99
//
//  Created by Ali Mousavi Roozbahani  on 2025-03-15.
//

import UIKit

extension Float {
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func kelvinToCeliusConverter() -> Float {
        let constantVal : Float = 273.15
        let kelValue = self
        let celValue = kelValue - constantVal
        return celValue.truncate(places: 1)
    }
}
