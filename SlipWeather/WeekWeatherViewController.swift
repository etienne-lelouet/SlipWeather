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
    
    @IBOutlet weak var DaySelectSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupSegmentedControl()
        // Do any additional setup after loading the view.
    }
    
    func formatDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd"
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString
    }
    
    func setupSegmentedControl() {
        DaySelectSegmentedControl.removeAllSegments()
        print(self.weekWeather.count)
        for i in 0...self.weekWeather.count - 1 {
            print(i)
            DaySelectSegmentedControl.insertSegment(withTitle: formatDate(for: weekWeather[i][0].date), at: i, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
