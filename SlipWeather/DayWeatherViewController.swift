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
    @IBOutlet weak var WindSpeedValue: UILabel!
    @IBOutlet weak var WindDirectionValue: UILabel!
    @IBOutlet weak var WeatherLogo: UIImageView!
    @IBOutlet weak var WeatherTitle: UILabel!
    @IBOutlet weak var WeatherDescription: UILabel!
    
    var dateFormatter: DateFormatter = DateFormatter()
    var currentWeatherIndex: Int = 0
    var timer = Timer()
    
    var dayWeather: [Forecast]!
    var displayedWeather: Forecast!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "EEEE, dd MMMM, HH:mm"
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData() { // MEGA FASTIDIEUUUUUX
        self.TitleBar?.text = dateFormatter.string(from: displayedWeather.date)
        self.CurrentTemperatureValue?.text = String(displayedWeather.temperature)
        self.MinTemperatureValue?.text = String(displayedWeather.temperatureMin)
        self.MaxTemperatureValue?.text = String(displayedWeather.temperatureMax)
        self.PressureValue?.text = String(displayedWeather.pressure)
        self.HumidityValue?.text = String(displayedWeather.humidity)
        self.CloudCoverageValue?.text = String(displayedWeather.cloudsCoverage)
        self.WindSpeedValue?.text = String(displayedWeather.windSpeed)
        self.WindDirectionValue?.text = String(displayedWeather.windOrientation)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.iterateWeather), userInfo: nil, repeats: true)
    }
    
    @objc func iterateWeather () -> Void {
        self.WeatherLogo?.image = displayedWeather.weather[currentWeatherIndex].icon
        self.WeatherTitle?.text = displayedWeather.weather[currentWeatherIndex].title
        self.WeatherDescription?.text = displayedWeather.weather[currentWeatherIndex].description
        if (self.currentWeatherIndex == displayedWeather.weather.count - 1) {
            self.currentWeatherIndex = 0
        } else {
            self.currentWeatherIndex += 1
        }
    }
    

    //TABLE VIEW METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCelle", for: indexPath)
            as! ForecastTableViewCell
        let forecast = dayWeather[indexPath.row]
        cell.DateValue?.text = dateFormatter.string(from: forecast.date)
        cell.TemperatureValue?.text = String(forecast.temperature)
        cell.WeatherLogo?.image = forecast.weather[0].icon
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldWeather: Forecast = self.displayedWeather
        self.displayedWeather = dayWeather[indexPath.row]
        timer.invalidate()
        self.dayWeather.remove(at: indexPath.row)
        self.dayWeather.append(displayedWeather)
        self.dayWeather.sort(by: { (forecast: Forecast, forecast2: Forecast) in
            return forecast.date < forecast2.date
        })
        OtherTimeTableView?.reloadData()
        self.loadData()
        
    }
}
