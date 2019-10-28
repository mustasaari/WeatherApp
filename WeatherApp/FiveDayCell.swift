//
//  FiveDayCell.swift
//  WeatherApp
//
//  Created by Mikko Mustasaari on 09/10/2019.
//  Copyright © 2019 Mikko Mustasaari. All rights reserved.
//

import UIKit

/*
 * Class for second screen tableview cell
 */

class FiveDayCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var imageCodeForAPI:String = ""
    var loadIndicator: UIActivityIndicatorView?
    
    func start() {
        loadIndicator = UIActivityIndicatorView(style: .gray)
        let container = UIView()
        container.frame = CGRect(x: cellImage.frame.width/2.5, y: cellImage.frame.height/2.1, width: 30, height: 30)
        //container.backgroundColor = .red
        container.addSubview(loadIndicator!)
        cellImage.addSubview(container)
        loadIndicator?.startAnimating()
    }
    
    //get weather icon if found in userdefaults use it, if not fetch it
    func getImage(imgCode: String) {
        
        imageCodeForAPI = imgCode
        
        //start caching
        let cacheManager = CacheManager()
        let cachePath = cacheManager.getCacheDirectory(filename: imgCode)
        if FileManager.default.fileExists(atPath: cachePath) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: cachePath))
                let img = UIImage(data: data)
                self.cellImage.image = img
                print("got image from cache")
                loadIndicator?.stopAnimating()
            } catch {
                print("error in loading")
            }
        }
        else {
            //fetch from api
            fetchImage(imgcode: imgCode)
        }
    }
    
    func setImage(img: Data) {  //25.10
        let img2 = UIImage(data: img)
        self.cellImage.image = img2
        self.loadIndicator?.stopAnimating()
        print("did set image")
    }
    
    func fetchImage(imgcode: String) {
        print("fetching image from internet")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url: URL? = URL(string: "https://openweathermap.org/img/wn/\(imgcode).png")
        let task = session.dataTask(with: url!, completionHandler: doneFetchingImage)
        task.resume()
    }
    
    //FETCHED IMAGE FROM API AND SAVED TO USERDEFAULTS
    func doneFetchingImage(data: Data?, response: URLResponse?, error: Error?) {
        DispatchQueue.main.async(execute: {() in
            
            let def = UserDefaults.standard   //UserDefaults kokeilu
            def.set(data, forKey: self.imageCodeForAPI)
            def.synchronize()
            
            let img = UIImage(data: data!)
            self.cellImage.image = img
            
            self.saveImage(data: data!, key: self.imageCodeForAPI)
            
            self.loadIndicator?.stopAnimating()
        })
    }
    
    func saveImage(data: Data, key: String) {
        print("Save data to cache")
        let cacheManager = CacheManager()
        let saveDirectory = cacheManager.getCacheDirectory(filename: key)
        do {
            try data.write(to: URL(fileURLWithPath: saveDirectory))
        } catch {
            
        }
    }
}
