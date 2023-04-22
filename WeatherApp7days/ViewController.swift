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
    
    var hourly = [Current]()
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
            
            let  hours = result.hourly
            self.hourly = hours
            
           // print(result.hourly)
            
            
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            // 1 cell that is a collectiontableviewcell
            return 1
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // Continue
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.configure(with: hourly)
            return cell
        }
        
        // Continue
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


