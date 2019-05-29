//
//  WeatherViewController.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 27/05/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather
import CoreData

class WeatherViewController: UIViewController {
    
    var city: City!
    var isFavorite: Bool? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var isFavoriteSwitch: UISwitch!
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        navigationBar.topItem?.title = city.name + ", " + city.country
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            request.predicate = NSPredicate(format: "identifier == %lld", city.identifier)
            request.fetchLimit = 1
            let fetchedResult = try self.context.fetch(request)
            if (fetchedResult.count == 1) {
                isFavorite = true
                isFavoriteSwitch.isOn = true
            } else {
                isFavorite = false
                isFavoriteSwitch.isOn = false
            }
        }
        catch {
            print ("fetch task failed", error)
        }
    }
    
    @IBAction func OnExit(_ sender: Any) {
        performSegue(withIdentifier: "BackOnSearchSegue", sender: self)
    }
    
    @IBAction func cityWasFaved(_ sender: Any) {
        let unwrappedIsFavorite = isFavorite!
        if (unwrappedIsFavorite) {
            do {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
                request.predicate = NSPredicate(format: "identifier == %lld", city.identifier)
                request.fetchLimit = 1
                let fetchedResult = try self.context.fetch(request)
                if (fetchedResult.count == 1) {
                    let cityToDelete = fetchedResult[0] as! NSManagedObject
                    self.context.delete(cityToDelete)
                    isFavorite = false
                    isFavoriteSwitch.isOn = false
                } else {
                    isFavorite = true
                    isFavoriteSwitch.isOn = true
                }
            } catch {
                print("Failed deleting")
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)
            let favorite = NSManagedObject(entity: entity!, insertInto: context)
            favorite.setValue(self.city.name, forKey: "name")
            favorite.setValue(self.city.country, forKey: "country")
            favorite.setValue(self.city.identifier, forKey: "identifier")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
