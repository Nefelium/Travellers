//
//  CitiesViewController.swift
//  Travellers
//
//  Created by admin on 02.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation


class CitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var sortUserId = true
    var sortCity = true
    
    private var itemRow: Int? = nil
    
    var cities = Database.instance.getCities()
    
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var userCodeField: UITextField!
    @IBAction func citiesAddButton(_ sender: Any) {
        if cityNameField.text != "" && userCodeField.text != "" {
            Database.instance.addCity(cname: cityNameField.text!, uid: Int(userCodeField.text!))
        }
        cities = Database.instance.getCities()
        tableView.reloadData()
    }
    @IBAction func citiesUpdateButton(_ sender: Any) {
        if itemRow != nil && userCodeField.text != "" {
            Database.instance.updateCity(cid: cities[itemRow!].id, uid: Int(userCodeField.text!))
            cities = Database.instance.getCities()
            tableView.reloadData()
        }
    }
    @IBAction func citiesDeleteButton(_ sender: Any) {
        if itemRow != nil {
            cities.remove(at: itemRow!)
            tableView.deleteRows(at: [IndexPath(row: itemRow!, section: 0)], with: .fade)
            Database.instance.deleteCity(uid: cities[itemRow!].id)
            cities = Database.instance.getCities()
            tableView.reloadData()
        }
        
    }
    @IBAction func citiesFilterButton(_ sender: Any) {
        cities = Database.instance.filterCity(cname: cityNameField.text!, ucode: Int(userCodeField.text!))
        tableView.reloadData()
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func sortCityColumn(_ sender: AnyObject) {
        if sortCity {
            cities.sort(by: { $0.name < $1.name })
            sortCity = false
            sender.setTitle("▲", for: .normal)
        } else {
            cities.sort(by: { $0.name > $1.name })
            sortCity = true
            sender.setTitle("▼", for: .normal)
        }
        tableView.reloadData()
    }
    
    @IBAction func sortUserIdColumn(_ sender: AnyObject) {
        if sortUserId {
            cities.sort(by: { $0.userId! < $1.userId! })
            sortUserId = false
            sender.setTitle("▲", for: .normal)
        } else {
            cities.sort(by: { $0.userId! > $1.userId! })
            sortUserId = true
            sender.setTitle("▼", for: .normal)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell")! as! CitiesTableViewCell
        let city = cities[indexPath.row]
        cell.cityCell = city
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row > -1) {
            itemRow = indexPath.row
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

   

}
