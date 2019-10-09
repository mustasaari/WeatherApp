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
    @IBOutlet weak var forecastTableFiveDays: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Second viewDidLoad")
        //self.forecastTableFiveDays.dataSource = self
        //self.forecastTableFiveDays.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(stuff[indexPath.row])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Second view did appear")
        stuff[2] = "yayyyy" //muuta dataa tableviewissä
        self.forecastTableFiveDays.reloadData() //reload tableview
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stuff.count
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "fivedaycell")
        
        print("got so far...")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fivedaycell", for: indexPath) as! FiveDayCell
        cell.label.text = self.stuff[indexPath.row]
        
        //if (cell == nil) {
        //    cell = UITableViewCell(style: .default, reuseIdentifier: "fivedaycell")
        //}
        //cell!.textLabel!.text = self.stuff[indexPath.row]
        
        return cell
    }
    
    
    
    
}
