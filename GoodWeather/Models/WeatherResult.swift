//
//  WeatherResult.swift
//  GoodWeather
//
//  Created by Mehmet  Kulakoğlu on 14.10.2022.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
