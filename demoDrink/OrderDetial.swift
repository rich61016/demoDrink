//
//  OrderDetial.swift
//  demoDrink
//
//  Created by YA on 2021/4/25.
//

import Foundation
import FirebaseDatabase

struct OrderDetial {
    
     var menu: String
     var size: String
     var price: Int
     var sweet: String
     var ice: String
     var feed: String
     var qty: Int
     var remarks: String?
     var total: Int
     var user: String
     var key: String
     var order_name:String
    
    init(snapshot: DataSnapshot) {
        print(snapshot)
        // 取出snapshot的值(JSON)
        
        let snapshotValue: [String: AnyObject] = snapshot.value as! [String: AnyObject]
        self.menu = snapshotValue["menu"] as! String
        self.size = snapshotValue["size"] as! String
        self.price = snapshotValue["price"] as! Int
        self.sweet = snapshotValue["sweet"] as! String
        self.ice = snapshotValue["ice"] as! String
        self.feed = snapshotValue["feed"] as! String
        self.qty = snapshotValue["qty"] as! Int
        self.remarks = snapshotValue["remarks"] as? String
        self.total = snapshotValue["total"] as! Int
        self.user = snapshotValue["user"] as! String
        self.key = snapshotValue["key"] as! String
        self.order_name = snapshotValue["order_name"] as! String
        
        
       
        
    }

}
