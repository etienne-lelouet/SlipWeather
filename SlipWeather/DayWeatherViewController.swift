//
//  CurrentWeatherViewController.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 02/06/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather

class ForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var DateValue: UILabel!
    @IBOutlet weak var TemperatureValue: UILabel!
    @IBOutlet weak var WindSpeedValue: UILabel!
    @IBOutlet weak var WeatherTitle: UILabel!
    @IBOutlet weak var WeatherLogo: UIImageView!
}

class DayWeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var OtherTimeTableView: UITableView!
    @IBOutlet weak var TitleBar: UILabel!
    @IBOutlet weak var CurrentTemperatureValue: UILabel!
    @IBOutlet weak var MinTemperatureValue: UILabel!
    @IBOutlet weak var MaxTemperatureValue: UILabel!
    @IBOutlet weak var PressureValue: UILabel!
    @IBOutlet weak var HumidityValue: UILabel!
    @IBOutlet weak var CloudCoverageValue: UILabel!
    @IBOutlet weak var WeatherLogo: UIImageView!
    @IBOutlet weak var WeatherTitle: UILabel!
    @IBOutlet weak var WeatherDescription: UILabel!
    @IBOutlet weak var WindSpeedValue: UILabel!
    @IBOutlet weak var WindDirectionValue: UILabel!
    
    var dayWeather: [Forecast]!
    var displayedWeather: Forecast!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        print(self.displayedWeather.date)
        
    }
    

    //TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
