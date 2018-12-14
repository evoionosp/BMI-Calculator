//
//  Item.swift
//  To Do List App
//
//  Created by Shubh Patel on 2018-11-27.
//  Copyright © 2018 Shubh Patel. All rights reserved.
//

import UIKit

class Record{
        var id: String?
        var isMetric: Bool?
        var weight: Double?
        var height: Double?
        var date: String?
    var isFav: Bool?
        
    init(id: String?, isMetric: Bool?, weight: Double?, height: Double?, date: String?, isFav: Bool?){
            self.id = id
            self.isMetric = isMetric
            self.weight = weight
            self.height = height
            self.date = date
            self.isFav = isFav
        }

    init() {
    }

}
