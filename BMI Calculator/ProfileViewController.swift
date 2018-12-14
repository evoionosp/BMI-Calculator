//
//  ProfileViewController.swift
//  BMI Calculator
//
//  Created by Shubh Patel on 2018-12-14.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var bDate: UIDatePicker!
    @IBOutlet weak var gender: UISegmentedControl!
    
    var firebaseDataRef: DatabaseReference!
    
     let dateFormatter = DateFormatter()
    
    var key: String!
    var isSaved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseDataRef = Database.database().reference(withPath: "Profile")
    
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
    
        firebaseDataRef.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                let prof =  (snapshot.children.nextObject() as! DataSnapshot).value as? [String: AnyObject]
                self.isSaved = true
                self.key = (prof?["id"] as! String)
                self.name.text = (prof?["name"] as! String)
                self.bDate.date = self.dateFormatter.date(from: (prof?["date"] as! String))!
                self.gender.selectedSegmentIndex = prof?["gender"] as! Int
        }
        })
                

        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSaveProfile(_ sender: Any) {
        
        if(!self.isSaved){
            key = firebaseDataRef.childByAutoId().key!
        }
        let item = ["id": key!,
                    "name": name.text! as String,
                    "gender": gender.selectedSegmentIndex,
                    "date": dateFormatter.string(from: bDate.date),
            ] as [String : Any]
        
        firebaseDataRef.child(key!).setValue(item)
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
    }
    
}
}
