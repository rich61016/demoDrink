//
//  OrderDetialViewController.swift
//  demoDrink
//
//  Created by YA on 2021/4/25.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase


class OrderDetialViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var db: DatabaseReference!
    var orderDetial: [OrderDetial] = [OrderDetial]()
    var total:Int = 0
    
    @IBOutlet var ordertableView: UITableView!
    
    @IBOutlet weak var order_count: UILabel!
    @IBOutlet weak var total_price: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        db = Database.database().reference(withPath: "orderReviews")

        db.observe(.value, with: { snapshot in
                        var dataList: [OrderDetial] = [OrderDetial]()
                        
                        for item in snapshot.children {
                            let data = OrderDetial(snapshot: item as! DataSnapshot)
                            dataList.append(data)
                        }
                        self.orderDetial = dataList
                       self.ordertableView.reloadData()
          
                })
        
        //計算單數
        db.observe(.value, with: { snapshot in
            let count = snapshot.childrenCount
            self.order_count.text = "單數 : \(count)"
                })
        
        //計算總金額
        db.observe(.value, with: { snapshot in
            if snapshot.childrenCount > 0 {
                self.total = 0
                for item in snapshot.children {
                    let data = OrderDetial(snapshot: item as! DataSnapshot)
                    self.total += data.total
                }
                self.total_price.text = "總金額 ：\(self.total)"
            }else{
                self.total_price.text = "總金額 ： 0"
            }
                    
                })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderDetial.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderDetialTableViewCell

        cell.name.text = "名字 ：\(self.orderDetial[indexPath.row].order_name)"
        cell.menu.text = "飲料 ：\(self.orderDetial[indexPath.row].menu)"
        cell.ice.text = "冰塊 ：\(self.orderDetial[indexPath.row].ice)"
        cell.size.text = "大小 ：\(self.orderDetial[indexPath.row].size)"
        cell.sweet.text = "甜度 ：\(self.orderDetial[indexPath.row].sweet)"
        cell.qty.text = "數量 ：\(self.orderDetial[indexPath.row].qty)"
        cell.feed.text = "加白玉 ：\(self.orderDetial[indexPath.row].feed)"
        cell.price.text = "金額 ：\(self.orderDetial[indexPath.row].total)"
        cell.remarks.text = "備註 ：\(self.orderDetial[indexPath.row].remarks ?? "無")"
        


        return cell
    }
    
    
    //往左滑顯示刪除按鈕
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let contextItem = UIContextualAction(style: .destructive, title: "刪除") {  (contextualAction, view, boolValue) in
        let key = self.orderDetial[indexPath.row].key
//        刪除訂單
        self.db.child(key).removeValue { error,arg  in
          if error != nil {
            print("error \(String(describing: error))")
          }
        }
       }
       let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

       return swipeActions
   }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(orderDetial[indexPath.row].key)
                
    
    }
    @IBSegueAction func edit(_ coder: NSCoder) -> EditOrderViewController? {
        guard let row = ordertableView.indexPathForSelectedRow?.row else { return nil }
        return EditOrderViewController(coder: coder, order: orderDetial[row])
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    

}
