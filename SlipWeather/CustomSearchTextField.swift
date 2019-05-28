//
//  CustomSearchTextField.swift
//  SlipWeather
//
//  Created by Etienne Le Louet on 26/05/2019.
//  Copyright © 2019 slipSoft. All rights reserved.
//

import UIKit
import Weather

class CustomSearchTextField: UITextField, UITableViewDataSource, UITableViewDelegate {
    var resultsList: [City] = [City]()
    var tableView: UITableView?
    let weatherClient: WeatherClient = WeatherClient(key: "2dd8f457671f8f42cf85af02cf47ca48")
    var performSegueOnSelect: ((City) -> Void)? = nil
    var isFiltering = false
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    //////////////////////////////////////////////////////////////////////////////
    // Text Field related methods
    //////////////////////////////////////////////////////////////////////////////
    
    @objc open func textFieldDidChange(){
        filter()
    }
    
    @objc open func textFieldDidBeginEditing() {
        print("Begin Editing")
    }
    
    @objc open func textFieldDidEndEditing() {
        print("End editing")
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        print("End on Exit")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
    }
    
    func buildSearchTableView() {
        
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)
            
        } else {
            print("tableView created")
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    // MARK: TableViewDataSource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList.count
    }
    
    //Adding rows in the tableview with the data from dataList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        let city = resultsList[indexPath.row];
        cell.textLabel?.text = city.name + ", " + city.country
        return cell
    }
    
    // MARK: TableViewDelegate methods
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = resultsList[indexPath.row]
        self.text = city.name + ", " + city.country
        performSegueOnSelect?(city)
        tableView.isHidden = true
        self.endEditing(true)
    }

    // Updating SearchtableView
    func updateSearchTableView() {
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            tableView.reloadData()
        }
    }

    fileprivate func filter() {
        if let unwrappedText = text {
            DispatchQueue.global(qos: .userInitiated).async{
                print("searching")
                print(unwrappedText)
                self.isFiltering = true;
                let results: [City] = self.weatherClient.citiesSuggestions(for: unwrappedText)
                DispatchQueue.main.async {
                    let maxLen = results.count <= 20 ? results.count : 20
                    self.resultsList = Array(results[0..<maxLen])
                    self.tableView?.reloadData()
                    self.tableView?.isHidden = false
                    self.updateSearchTableView()
                }
            }
        }
    }
}
