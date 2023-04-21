//
//  ViewController.swift
//  WeatherApp7days
//
//  Created by Carrington Tafadzwa Manyuchi on 2023/04/21.

//****
//****
//**************************************************
// *** List of things we gonna need in this project ****
// 1. Location - to get us to know users area
// 2. TableView - To show the weather list of the upcoming days
// 3. Custom cell: Collection View - Horizontal table which shows the hourly forecast of the current day
// 4. API / Request to get the data
// 5. Get locations first, then find weather using location coordinates
//****
//****
//**************************************************
import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var  table: UITableView!
    
    var models = [Daily]()
    var current: Current?
    
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register two cells
        table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    //MARK: - Location
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,alerts&appid=a939b3a2c089cdc4dcefee3b74142319&units=metric"
        
        let url2 = "https://api.openweathermap.org/data/2.5/onecall?lat=-26.005&lon=28.0039&exclude=minutely,alerts&appid=a939b3a2c089cdc4dcefee3b74142319"
        print(url2)
        
        print("\(long) & \(lat)"  )
        
        //make a request with a datatask
        
        let dataTask = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
             // validation
            
            guard let data = data, error == nil else {
                print("Data validation is wrong")
                return
            }
            
            //convert data to models / some object
            
            var json: Weather?
            
            do {
                json = try JSONDecoder().decode(Weather.self, from: data)
            } catch {
                print("error : \(error)")
            }
            
            guard let result = json else {
                return
            }
            
            let entries = result.daily
            self.models.append(contentsOf: entries)
            
            
            let current = result.current
            self.current = current
            
            
            // update user interface

            DispatchQueue.main.async {
                self.table.reloadData()
                
                self.table.tableHeaderView = self.createTableHeader()
            }
            // update user interface

        }
        dataTask.resume()
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        headerView.backgroundColor = .cyan
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/5))
       
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 10+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerView.frame.size.height/2))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(summaryLabel)
        headerView.addSubview(tempLabel)
        
        tempLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        
        
        guard let currentWeather = self.current else {
            return UIView()
        }
        
        summaryLabel.text = "\(currentWeather.weather[0].main)"
        locationLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(currentWeather.dt)))
        tempLabel.text = "\(currentWeather.temp)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        
        func getDayForDate(_ date: Date?) -> String {
            guard let inputDate = date else {
                return ""
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: inputDate)
        }

        return headerView
    }
    
    
    //MARK: - Basic Table Functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

// MARK: - Weather
struct Weather: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [WeatherElement]
    let windGust: Double?
    let pop: Int?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
        case windGust = "wind_gust"
        case pop
    }
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main: Main
    let description: Description
    let icon: String
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [WeatherElement]
    let clouds: Int
    let pop, uvi: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
