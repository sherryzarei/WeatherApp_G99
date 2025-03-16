//
//  Untitled.swift
//  WeatherApp_G99
//
//  Created by Ali Mousavi Roozbahani  on 2025-03-15.
//

import UIKit

extension Int {
    
    /// Returns the result of incrementing the weekday index by a given number, wrapping within 0...6.
    func addingWeekdays(_ value: Int) -> Int {
        return (self + value) % 7
    }
}
