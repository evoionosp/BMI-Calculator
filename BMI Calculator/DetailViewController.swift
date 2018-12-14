//
//  DetailViewController.swift
//  To Do List App
//
//  Created by Shubh Patel on 2018-12-06.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    

    var item: Record = Record()
    var isSaved: Bool = false
    
    @IBOutlet weak var segUnit: UISegmentedControl!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var lbHeight: UILabel!
    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var swMilestone: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let dateFormatter = DateFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        if(isSaved){
            if(!item.isMetric!){ segUnit.selectedSegmentIndex = 1}
            tfWeight.text = item.weight?.description
            tfHeight.text = item.height?.description
            swMilestone.isOn = item.isFav!
            datePicker.date = dateFormatter.date(from: item.date!)!
            
            refreshBMI()
            
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onValueChange(_ sender: UITextField) {
        
         refreshBMI()
    }
    
    @IBAction func onUnitChange(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0){
            lbHeight.text = "m"
            lbWeight.text = "Kg"
        } else {
            lbHeight.text = "Inches"
            lbWeight.text = "Pounds"
        }
        refreshBMI()
    }
    
    @IBAction func onSaveClick(_ sender: UIButton) {
       
        var key: String?
        if(!isSaved){
        key = AppDelegate.firebaseDataRef.childByAutoId().key!
        } else {
        key = self.item.id!
        }
        
        
        
//        let now = dateformatter.stringFromDate(NSDate())
//
//        let date = dateFormatter.date(from: stringDate)
        
        let item = ["id": key!,
                    "isMetric": segUnit.selectedSegmentIndex == 0,
                        "weight": tfWeight.text!,
                        "height": tfHeight.text!,
                        "date": dateFormatter.string(from: datePicker.date),
                        "isFav": swMilestone.isOn
                ] as [String : Any]
        
        AppDelegate.firebaseDataRef.child(key!).setValue(item)
        
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func calculateBMI(isMetric: Bool, height: Double, weight: Double) -> Double {
        var bmi: Double = 0
        if(isMetric){
            bmi = try! weight/(height*height)
        } else {
            bmi = try! (weight*703)/(height*height)
        }
        if(bmi <= 0){
            lbStatus.textColor = UIColor.red
            lbStatus.text = "INVALID"
        } else if (bmi <= 18.5){
            lbStatus.textColor = UIColor.orange
            lbStatus.text = "UNDER-WEIGHT"
        } else if (bmi <= 25){
            lbStatus.textColor = UIColor.green
            lbStatus.text = "HEALTHY"
        } else if (bmi <= 35){
            lbStatus.textColor = UIColor.orange
            lbStatus.text = "OVER-WEIGHT"
        } else{
            lbStatus.textColor = UIColor.red
            lbStatus.text = "INVALID"
        }
        return bmi
        
        
    }
    
    func doubleRound(result: Double) -> String {
        let finalAns = String(format: "%g", result)
        return finalAns
    }
    
    func refreshBMI() {
  
        lbScore.text = try! doubleRound(result: calculateBMI(isMetric: segUnit.selectedSegmentIndex == 0, height: (tfHeight.text! as NSString).doubleValue, weight: (tfWeight.text! as NSString).doubleValue))
        
    }

}
