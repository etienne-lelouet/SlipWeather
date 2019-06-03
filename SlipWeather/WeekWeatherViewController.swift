//
//  ForeacstViewController.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 02/06/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather

class WeekWeatherViewController: UIViewController {

    var maxDateDisplay: Int  = 5
    var weekWeather: [[Forecast]]!
    var dayVC: DayWeatherViewController!
    
    
    
    @IBOutlet weak var DaySelectSegmentedControl: UISegmentedControl!
    @IBOutlet weak var WeatherContainer: UIView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupChildViews()
        setupSegmentedControl()
    }
    
    
    func setupChildViews() {
        self.dayVC = self.storyboard?.instantiateViewController(withIdentifier: "dayVC") as? DayWeatherViewController
        self.addChild(self.dayVC)
        let selectedDayWeather = weekWeather[0]
        self.dayVC.displayedWeather = selectedDayWeather[0]
        self.dayVC.dayWeather = Array(selectedDayWeather.dropFirst())
        dayVC.view.frame = self.WeatherContainer.bounds
        self.WeatherContainer.addSubview(dayVC.view)
    }

    func formatDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd"
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString
    }
    
    func setupSegmentedControl() {
        DaySelectSegmentedControl.removeAllSegments()
        for i in 0...self.weekWeather.count - 1 {
            DaySelectSegmentedControl.insertSegment(withTitle: formatDate(for: weekWeather[i][0].date), at: i, animated: true)
        }
        DaySelectSegmentedControl.selectedSegmentIndex = 0
        DaySelectSegmentedControl.setEnabled(true, forSegmentAt: 0)
        DaySelectSegmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        self.dayVC.timer.invalidate()
        let selectedDayWeather = weekWeather[sender.selectedSegmentIndex]
        self.dayVC.displayedWeather = selectedDayWeather[0]
        self.dayVC.dayWeather = Array(selectedDayWeather.dropFirst())
        self.dayVC.loadData()
    }
}
