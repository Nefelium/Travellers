//
//  Database.swift
//  Travellers
//
//  Created by admin on 27.04.2018.
//  Copyright © 2018 admin. All rights reserved.
//

import Foundation
import SQLite

protocol DataBaseDelegate: class {
    func updateData()
}

class Database {
 
    weak var delegate: DataBaseDelegate?
    static let instance = Database()
    private var db: Connection?
    
    private let users = Table("users")
    private let cities = Table("cities")
    private let travellers = Table("travellers")
    private let id = Expression<Int>("id")
    private let userId = Expression<Int?>("userId")
    private let name = Expression<String>("name")
    private let user = Expression<String>("user")
    private let city = Expression<String>("city")
    
    private init() {
        
        do {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!

        // create parent directory if it doesn’t exist
        try FileManager.default.createDirectory(
            atPath: path, withIntermediateDirectories: true, attributes: nil
        )
        
        
            db = try Connection("\(path)/db.sqlite3")
            try db?.execute("PRAGMA foreign_keys = ON;")
            print(path) // вывод пути к базе данных в консоль
        } catch {
            db = nil
            Alerts.alert(title: "Error", message: "Unable to open database")
           
        }
        createTableUsers()
        createTableCities()
        createTableTravellers()
    }
    
    func createTableUsers() {
        do {
            try db!.run(users.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
        } catch {
            Alerts.alert(title: "Error", message: "Unable to create table")
        }
    }
    
    func createTableCities() {
        do {
            try db!.run(cities.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(userId)
                t.foreignKey(userId, references: users, id, delete: .setNull)
            })
        } catch {
             Alerts.alert(title: "Error", message: "Unable to create table")
        }
    }
    
    func createTableTravellers() {
        do {
            try db!.run(travellers.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(user)
                t.column(city)
            })
        } catch {
             Alerts.alert(title: "Error", message: "Unable to create table")
        }
    }
    
    func addUser(uname: String) {
        do {
            let filteredTable = users.filter(name == uname)
            if try (db?.run(filteredTable.update(name <- uname)))! > 0 {
                 Alerts.alert(title: "Error", message: "Row existing")
            } else {
            let insert = users.insert(or: .replace, name <- uname)
            try db!.run(insert)
            self.delegate?.updateData()
        }
        } catch {
             Alerts.alert(title: "Error", message: "Insert failed")
        }
    }
    
    func addCity(cname: String, uid: Int?) {
        do {
            let filteredTable = cities.filter(name == cname && userId == uid)
            if try (db?.run(filteredTable.update(name <- cname)))! > 0 {
               Alerts.alert(title: "Error", message: "Row existing")
            } else {
                let insert = cities.insert(name <- cname, userId <- uid!)
            let id = try db!.run(insert)
                if id > 0 { addTraveller(userid: uid!, cityname: cname) }
                self.delegate?.updateData()
            }
        } catch {
            Alerts.alert(title: "Error", message: "Insert failed")
        }
    }
    
    
    func addTraveller(userid: Int?, cityname: String) {
        do {
            if let trav = try db?.pluck(users.filter(id == userid!)) {
                let insert = travellers.insert(or: .replace, user <- trav[name], city <- cityname)
                try db!.run(insert)
            }
        }  catch {
            Alerts.alert(title: "Error", message: "Insert failed")
    }
    }
    
    func getUsers() -> [UserModel] {
        var users = [UserModel]()
        do {
            for user in try db!.prepare(self.users) {
                users.append(UserModel(
                    id: user[id],
                    name: user[name]))
            }
        } catch {
            Alerts.alert(title: "Error", message: "Insert failed")
        }
        return users
    }

    
    func getCities() -> [CityModel] {
        var cities = [CityModel]()
        
        do {
            for city in try db!.prepare(self.cities) {
                cities.append(CityModel(
                    id: city[id],
                    name: city[name],
                    userId: city[userId]!
                    ))
            }
        } catch {
            Alerts.alert(title: "Error", message: "Select failed")
        }
        return cities
    }
    
    
    func getTravellers() -> [TravellerModel] {
        var travels = [TravellerModel]()
        do {
            let query = travellers.order(name)
            for traveller in try db!.prepare(query) {
                travels.append(TravellerModel(
                    id: traveller[id],
                    user: traveller[user],
                    city: traveller[city]))
            }
        } catch {
            Alerts.alert(title: "Error", message: "Select failed")
        }
        return travels
    }
    
    func filterUser(uname: String) -> [UserModel] {
        var usersFiltered = [UserModel]()
        do {
            var count = 0
            let filterusers = users.filter(name == uname)
            count = (try db?.scalar(filterusers.count))!
            if count > 0 {
            for user in try db!.prepare(filterusers) {
                usersFiltered.append(UserModel(
                    id: user[id],
                    name: user[name]))
            }
                return usersFiltered
            } else { return getUsers() }
        } catch {
            Alerts.alert(title: "Error", message: "Select failed")
            return getUsers()
        }
        
    }
    
    func filterCity(cname: String, ucode: Int?) -> [CityModel] {
        var cityFiltered = [CityModel]()
        var filtercities = cities.filter(name == cname && userId == ucode)
        do {
            var count = 0
            if cname != "" && ucode != nil {
            filtercities = cities.filter(name == cname && userId == ucode)
            } else if cname == "" && ucode != nil {
             filtercities = cities.filter(userId == ucode)
            } else if cname != "" && ucode == nil {
             filtercities = cities.filter(name == cname)
            } else { }
            count = (try db?.scalar(filtercities.count))!
            if count > 0 {
                for city in try db!.prepare(filtercities) {
                    cityFiltered.append(CityModel(
                        id: city[id],
                        name: city[name],
                        userId: city[userId]!))
                }
                return cityFiltered
            } else { return getCities() }
        } catch {
            Alerts.alert(title: "Error", message: "Not found")
          return getCities()
        }
    }
    
    func filterTraveller(uname: String, cname: String) -> [TravellerModel] {
        var travelFiltered = [TravellerModel]()
        var filtertravel = travellers.filter(user == uname && city == cname)
        do {
            var count = 0
            if uname != "" && cname != "" {
                filtertravel = travellers.filter(user == uname && city == cname)
            } else if uname == "" && cname != "" {
                filtertravel = travellers.filter(city == cname)
            } else if uname != "" && cname == "" {
                filtertravel = travellers.filter(user == uname)
            } else { }
            count = (try db?.scalar(filtertravel.count))!
            if count > 0 {
                for trav in try db!.prepare(filtertravel) {
                    travelFiltered.append(TravellerModel(
                        id: trav[id],
                        user: trav[user],
                        city: trav[city]))
                }
                return travelFiltered
            } else { return getTravellers() }
        } catch {
            Alerts.alert(title: "Error", message: "Not found")
            return getTravellers()
        }
    }
    
    func updateUser(uid:Int, uname: String) {
        let changeUser = users.filter(id == uid)
        do {
            if let trav = try db?.pluck(changeUser) {
                let changeTraveller = travellers.filter(user == trav[name])
            let update = changeUser.update([
                name <- uname
                ])
            if try db!.run(update) > 0 {
                    do {
                        let update = changeTraveller.update([
                            user <- uname
                            ])
                        if try db!.run(update) > 0 {
                            
                        }
                    } catch {
                        Alerts.alert(title: "Error", message: "Update failed: \(error)")
                    }
                }
                self.delegate?.updateData()
                
            }
        } catch {
            Alerts.alert(title: "Error", message: "Update failed: \(error)")
        }
       
    }
    
    func updateCity(cid:Int, uid: Int?)  {
         let changeCity = cities.filter(id == cid)
        do {
            if let trav = try db?.pluck(changeCity) {
                let changeTraveller = travellers.filter(city == trav[name])
                let usr = try db?.pluck(users.filter(id == uid!))
                let update = changeCity.update([
                    userId <- uid
                    ])
                if try db!.run(update) > 0 {
                    do {
                        let update = changeTraveller.update([
                            user <- usr![name]
                            ])
                        if try db!.run(update) > 0 {
                        }
                    } catch {
                        Alerts.alert(title: "Error", message: "Update failed: \(error)")
                    }
                }
            }
        } catch {
            Alerts.alert(title: "Error", message: "Update failed: \(error)")
        }
        self.delegate?.updateData()
    }
    
   // Administrator methods
    
    func dropUsers() {
        do {
            try db?.run(users.drop())
        } catch {
            Alerts.alert(title: "Error", message: "Drop failed")
        }
    }
    
    func dropCities() {
        do {
            try db?.run(cities.drop())
        } catch {
            Alerts.alert(title: "Error", message: "Drop failed")
        }
    }
    
    func dropTravellers() {
        do {
            try db?.run(travellers.drop())
        } catch {
            Alerts.alert(title: "Error", message: "Drop failed")
        }
    }
    
    func deleteUsers() {
        do {
            try db?.run(users.delete())
        } catch {
            Alerts.alert(title: "Error", message: "Drop failed")
        }
    }
    
    func deleteCities() {
        do {
            try db?.run(cities.delete())
        } catch {
            Alerts.alert(title: "Error", message: "Drop failed")
        }
    }
    
    func deleteTravellers() {
        do {
            try db?.run(travellers.delete())
        } catch {
            Alerts.alert(title: "Error", message: "Drop failed")
        }
    }
    
    func deleteUser(uid: Int) -> Bool {
        do {
            let user = users.filter(id == uid)
            try db!.run(user.delete())
            return true
        } catch {
            Alerts.alert(title: "Error", message: "Delete failed")
        }
        return false
    }
    
    func deleteCity(uid: Int) -> Bool {
        do {
            let deletingCity = cities.filter(id == uid)
            if let trav = try db?.pluck(deletingCity) {
                let deletingTraveller = travellers.filter(city == trav[name])
                try db!.run(deletingCity.delete())
                try db!.run(deletingTraveller.delete())
                self.delegate?.updateData()
                return true
            }
        } catch {
            Alerts.alert(title: "Error", message: "Delete failed")
        }
        return false
    }
    
    func findUser(uid: Int) -> String {
        do {
            var username = ""
            let filteredUser = users.filter(id == uid)
            for user in (try db?.prepare(filteredUser))! {
                username = user[name]
            }
            Alerts.alert(title: "Error", message: "User not found")
            return username
        } catch {
            Alerts.alert(title: "Error", message: "User not found")
        }
        return ""
    }
    
    func filterTravellersByUser(uname: String) -> Table {
        do {
            var count = 0
            let filteruser = travellers.filter(user == uname)
            count = (try db?.scalar(filteruser.count))!
            if count > 0 { return filteruser } else { return travellers }
        } catch {
            Alerts.alert(title: "Error", message: "Not found")
            return travellers
        }
    }
    
    func fillTravellers() {
        do {
            try db?.run(travellers.delete())
            for traveller in (try db?.prepare(cities))! {
                if let trav = try db?.pluck(users.filter(id == traveller[userId]!)) {
                    let insert = travellers.insert(user <- trav[name], city <- traveller[name])
                    try db!.run(insert)
                }
            }
        } catch {
            Alerts.alert(title: "Error", message: "Insert failed")
        }
    }
    

}
