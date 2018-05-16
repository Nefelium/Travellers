//
//  ViewController.swift
//  Travellers
//
//  Created by admin on 27.04.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Foundation

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sortId = false
    var sortName = true
    
    var itemRow: Int? = nil
    
    var users = Database.instance.getUsers()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBAction func userAddButton(_ sender: Any) {
        if userNameField.text != "" {
            Database.instance.addUser(uname: userNameField.text!)
            users = Database.instance.getUsers()
            tableView.reloadData()
        }
    }
    
    @IBAction func userUpdateButton(_ sender: Any) {
        if itemRow != nil && userNameField.text != "" {
            Database.instance.updateUser(uid: users[itemRow!].id, uname: userNameField.text!)
            users = Database.instance.getUsers()
            tableView.reloadData()
        }
    }
    @IBAction func userDeleteButton(_ sender: Any) {
        if itemRow != nil {
            if Database.instance.deleteUser(uid: users[itemRow!].id) {
            users.remove(at: itemRow!)
            tableView.deleteRows(at: [IndexPath(row: itemRow!, section: 0)], with: .fade)
            users = Database.instance.getUsers()
            tableView.reloadData()
            }
        }
    }
    @IBAction func userFilterButton(_ sender: Any) {
            users = Database.instance.filterUser(uname: userNameField.text!)
        tableView.reloadData()
    }
    
    @IBAction func sortIdColumn(_ sender: AnyObject) {
                if sortId {
                users.sort(by: { $0.id < $1.id })
                    sortId = false
                   sender.setTitle("▲", for: .normal)
                } else {
                  users.sort(by: { $0.id > $1.id })
                    sortId = true
                    sender.setTitle("▼", for: .normal)
                }
                tableView.reloadData()
    }
    @IBAction func sortNameColumn(_ sender: AnyObject) {
                if sortName {
                    users.sort(by: { $0.name < $1.name })
                    sortName = false
                    sender.setTitle("▲", for: .normal)
                } else {
                    users.sort(by: { $0.name > $1.name })
                    sortName = true
                    sender.setTitle("▼", for: .normal)
                }
                tableView.reloadData()
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell")! as! UsersTableViewCell
        let user = users[indexPath.row]
        cell.userCell = user
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
      // Database.instance.fillTravellers()
        
    }

  
    
}

