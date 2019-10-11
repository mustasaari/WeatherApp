//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 07/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import UIKit

class SecondView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var stuff = ["eka", "toka", "kolmas"]
    var fiveDayWeatherArray: WeatherStructFiveDay?
    var city = "London"
    
    @IBOutlet weak var forecastTableFiveDays: UITableView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Second viewDidLoad")
        //self.forecastTableFiveDays.dataSource = self
        //self.forecastTableFiveDays.delegate = self
    }
    
    //what happens on cell click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(stuff[indexPath.row])
        print("clicked")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Second view did appear")
        stuff[2] = "yayyyy" //muuta dataa tableviewissä
        
        city = UserDefaults.standard.string(forKey: "userLastLocation") ?? "London"
        self.locationLabel.text = "For Location \(city)"
        city = city.replacingOccurrences(of: " ", with: "+")
        self.forecastTableFiveDays.reloadData() //reload tableview
        
        //five day weather forecast url
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&units=metric&APPID=e5832b1e0a998a414175ccc09695ddc7")
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.stuff.count
        if let count = self.fiveDayWeatherArray?.list.count {
            print("COUNT")
            return count
        }
        else {
            print("array empty")
            return 0
        }
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "fivedaycell")
        
        print("Load tableview cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fivedaycell", for: indexPath) as! FiveDayCell
        
        //cell.label.text = self.stuff[indexPath.row]   //toimiva stuff lisäys labeliin
        //print(self.fiveDayWeatherArray?.list[indexPath.row].main.temp)
        //add weather main to label
        if let txt = self.fiveDayWeatherArray?.list[indexPath.row].weather[0].main {
            cell.label.text = txt
        }
        //add temperature to label
        if let txt = self.fiveDayWeatherArray?.list[indexPath.row].main.temp {
            let txt2 = String(format: "%.1f", txt)
            cell.label.text = (cell.label.text!) + "  \(txt2) °C"
        }
        //get icon for cell
        if let txt = self.fiveDayWeatherArray?.list[indexPath.row].weather[0].icon {
            //let txt2 = String(format: "%f", txt)
            //cell.label.text = "\(txt2) C"
            //cell.fetchImage(imgcode: txt)
            cell.getImage(imgCode: txt)
        }
        //add date for cell
        if let txt = self.fiveDayWeatherArray?.list[indexPath.row].dt_txt {
            cell.dateLabel.text = txt
        }
        
        //cell.label.text = self.fiveDayWeatherArray?.list[indexPath.row].main.temp
        
        //if (cell == nil) {
        //    cell = UITableViewCell(style: .default, reuseIdentifier: "fivedaycell")
        //}
        //cell!.textLabel!.text = self.stuff[indexPath.row]
        
        return cell
    }
    
    func fetchUrl(url: String) {
        print("start fetching")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: url)
        let task = session.dataTask(with: url!, completionHandler: doneFetching)
        task.resume()
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        print("print fect")
        DispatchQueue.main.async(execute: {() in
            NSLog(resstr!)
            self.readJSON2(data: data)
            self.forecastTableFiveDays.reloadData()
        })
    }
    
    func readJSON2 (data: Data?) {
        
        let decoder = JSONDecoder()
        
        do {
            let todo = try decoder.decode(WeatherStructFiveDay.self, from: data!)
            print(todo.cod)
            print(todo.list[0].dt_txt)
            print(todo.list[0].main.temp)   //weather
            self.fiveDayWeatherArray = todo
            
            //print(self.fiveDayWeatherArray?.list[0].main.temp)
            
        } catch {
            print("error yay")  //must make new struct for this fecth 10.10.2019 end note
        }
    }
    
    
    
    
}
