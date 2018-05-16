//
//  TravellersViewController.swift
//  Travellers
//
//  Created by admin on 02.05.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation

class TravellersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataBaseDelegate {

    var sortUser = true
    var sortCity = true
    
    var travellers = Database.instance.getTravellers()
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBAction func travellersFilter(_ sender: Any) {
        travellers = Database.instance.filterTraveller(uname: userField.text!, cname: cityField.text!)
        tableView.reloadData()
    }
    
    @IBAction func sortUserColumn(_ sender: AnyObject) {
        if sortCity {
            travellers.sort(by: { $0.user < $1.user })
            sortCity = false
            sender.setTitle("▲", for: .normal)
        } else {
            travellers.sort(by: { $0.user > $1.user })
            sortCity = true
            sender.setTitle("▼", for: .normal)
        }
        tableView.reloadData()
    }
    
    @IBAction func sortCityColumn(_ sender: AnyObject) {
        if sortCity {
            travellers.sort(by: { $0.city < $1.city })
            sortCity = false
            sender.setTitle("▲", for: .normal)
        } else {
            travellers.sort(by: { $0.city > $1.city })
            sortCity = true
            sender.setTitle("▼", for: .normal)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travellers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravellerCell")! as! TravellersTableViewCell
        let traveller = travellers[indexPath.row]
        cell.travellerCell = traveller
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Database.instance.delegate = self
        travellers = Database.instance.getTravellers()
    }


    func updateData() {
        travellers = Database.instance.getTravellers()
        tableView.reloadData()
    }
    
}
