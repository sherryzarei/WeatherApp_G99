//
//  DateExtension.swift
//  WeatherApp_G99
//
//  Created by Ali Mousavi Roozbahani  on 2025-03-15.
//

import UIKit

extension Date {
    
    /// Returns the full name of the day for the date (e.g., "Monday").
    var weekdayName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: self).capitalized
    }
}
