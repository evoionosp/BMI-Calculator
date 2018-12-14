//
//  ToDoListController.swift
//  To Do List App
//
//  Created by Shubh Patel on 2018-11-26.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit
import Firebase

class BMIListController: UITableViewController {

    var unpinItems: [Record] = []
    var pinItems: [Record] = []
    
    struct Category {
        let name : String
        var items : [Record]
    }

    var sections = [Category]()
    private static let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        AppDelegate.firebaseDataRef.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.pinItems.removeAll()
                self.unpinItems.removeAll()
                
                //iterating through all the values
                for items in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let item = items.value as? [String: AnyObject]
                    let id  = item?["id"] as! String
                    let weight = (item?["weight"] as! NSString).doubleValue
                    let height = (item?["height"] as! NSString).doubleValue
                   // let weight  = String(format: "%@", item?["weight"] as! CVarArg).floatValue
                  //  let height  = String(format: "%@", item?["weight"] as! CVarArg).floatValue
                    let date = item?["date"] as! String
                    let isFav = item?["isFav"] as! Bool
                    let isMetric = item?["isMetric"] as! Bool
                    
                    
                    //creating artist object with model and fetched values
                   
                    let itemObj = Record(id: id, isMetric: isMetric, weight: weight, height: height, date: date, isFav: isFav)
                    
                    //appending it to list
                    if(itemObj.isFav!){
                        self.pinItems.append(itemObj)
                    } else {
                        self.unpinItems.append(itemObj)
                    }
                    
                }
                
                self.sections = [Category(name:"Misestones", items:self.pinItems),
                            Category(name:"Records", items:self.unpinItems)]
                
                
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if showFavourites {
//            fontNames = FavoritesList.sharedFavoritesList.favorites
//            tableView.reloadData()
//        }
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = self.sections[section].items
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: BMIListController.cellIdentifier,
            for: indexPath) 
        
        let items = self.sections[indexPath.section].items
        
        cell.textLabel?.text = doubleRound(result: calculateBMI(isMetric: items[indexPath.row].isMetric!, height: items[indexPath.row].height!, weight: items[indexPath.row].weight!))
        cell.detailTextLabel?.text = items[indexPath.row].date
        return cell

        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController]
        // Pass the selected obiect to the new view controller
        
        if(segue.identifier == "edit"){
            let tableViewCell = sender as! UITableViewCell
            let indexPath  = tableView.indexPath(for: tableViewCell)!
            let item = self .sections[indexPath.section].items[indexPath.row]
            
            let newVC = segue.destination as! DetailViewController
            newVC.title = item.date
            newVC.item = item
            newVC.isSaved = true
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        AppDelegate.firebaseDataRef.child(self.sections[indexPath.section].items[indexPath.row].id!).removeValue()
           tableView.deleteRows(at: [indexPath], with: .fade)

        }
        
        let pin = UITableViewRowAction(style: .default, title: "Pin") { (action, indexPath) in
            // share item at indexPath
            
            let tmp = self.sections[indexPath.section].items[indexPath.row]
            
            //creating artist with the given values
            AppDelegate.firebaseDataRef.child(tmp.id!).updateChildValues(["isFav": true])
            print("Pinned")
        }
        
        let unpin = UITableViewRowAction(style: .default, title: "Un-Pin") { (action, indexPath) in
            // share item at indexPath
            
            let tmp = self.sections[indexPath.section].items[indexPath.row]
            //creating artist with the given values
            
            AppDelegate.firebaseDataRef.child(tmp.id!).updateChildValues(["isFav": false])
            print("Unpinned")
        }
        
        unpin.backgroundColor = UIColor.lightGray
        pin.backgroundColor = self.view.tintColor
    
        if(indexPath.section == 0){
            return [delete, unpin]
        } else {
            return [delete, pin]
        }
        
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    
    func calculateBMI(isMetric: Bool, height: Double, weight: Double) -> Double {
        if(isMetric){
            return weight/(height*height)
        } else {
            return (weight*703)/(height*height)
        }
    }
    
    func doubleRound(result: Double) -> String {
        let finalAns = String(format: "%g", result)
        return finalAns
    }
}
