//
//  Weather.swift
//  WeatherApp7days
//
//  Created by Carrington Tafadzwa Manyuchi on 2023/04/22.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

// MARK: - Weather
struct Weather: Codable {
    let current: Current
    let hourly: [Current]
    let daily: [Daily]

   
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let temp: Double
    let weather: [WeatherElement]
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let main: Main
}


enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}


// MARK: - Daily
struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let weather: [WeatherElement]
}

// MARK: - Temp
struct Temp: Codable {
    let min: Double
    let max: Double
}
