//
//  Menu.swift
//  demoDrink
//
//  Created by YA on 2021/4/24.
//

import Foundation
import FirebaseDatabase


struct Menu {
    
     var id: Int
     var name: String
     var priceM: Int
     var priceL: Int?
     var description: String
      
    init(snapshot: DataSnapshot) {
        print(snapshot)
        // 取出snapshot的值(JSON)
        
        let snapshotValue: [String: AnyObject] = snapshot.value as! [String: AnyObject]
        self.id = snapshotValue["id"] as! Int
        self.name = snapshotValue["name"] as! String
        self.priceM = snapshotValue["priceM"] as! Int
        self.priceL = snapshotValue["priceL"] as? Int
        self.description = snapshotValue["description"] as! String
        
    }

}
