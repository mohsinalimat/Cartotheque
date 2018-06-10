//
//  Card.swift
//  DUI002 Credit Card
//
//  Created by Tim on 15.06.17.
//  Copyright © 2017 Tim. All rights reserved.
//

import Foundation
import SwiftyJSON


struct CardData {
    var title: String?
    var number: String
    var cardholder: String
    var expires: String
    
    init(title: String?, number: String, cardholder: String, expires: String) {
        self.title = title
        self.number = number
        self.cardholder = cardholder
        self.expires = expires
    }
    
    init(json: JSON) {
        self.init(title: json["title"].stringValue, number: json["number"].stringValue, cardholder: json["card_holder"].stringValue, expires: json["expires"].stringValue)
    }
}
