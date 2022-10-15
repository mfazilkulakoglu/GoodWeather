//
//  URL+Extension.swift
//  GoodWeather
//
//  Created by Mehmet  Kulakoğlu on 14.10.2022.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=2e3a120f160139e7ac4f1cec9d7fa56b&units=imperial")
    }
}
