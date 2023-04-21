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
//****
//****
//**************************************************
import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var  table: UITableView!
    
    var models = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register two cells
        
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}



struct Weather{
    
}
