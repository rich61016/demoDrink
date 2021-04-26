//
//  EditOrderViewController.swift
//  demoDrink
//
//  Created by YA on 2021/4/26.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase

class EditOrderViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
  
    
    var db: DatabaseReference!
    
    //data是PickerView的內容
    var sweetdata = ["無糖(0%)","一分糖(10%)","二分糖(20%)","微糖(30%)","半糖(50%)","少糖(70%)","正常糖(100%)"]
    //產生PickerView
    var picker = UIPickerView()
    
    let orderDetial: OrderDetial
    
    init?(coder: NSCoder, order: OrderDetial) {
        self.orderDetial = order
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var iceString:String!
    var sweetString:String!
    var totalString:Int!
    var feedString:String!
    var addFeed:Int!
    var drinkQty:Int!
   
    
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var order_name: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var sizeSeg: UISegmentedControl!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sweet: UITextField!
    @IBOutlet weak var iceSeg: UISegmentedControl!
    @IBOutlet weak var addSwitch: UISwitch!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var qtyStepper: UIStepper!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var total: UILabel!
    
    
    
    @IBAction func ice(_ sender: Any) {
        let title = iceSeg.titleForSegment(at: iceSeg.selectedSegmentIndex)
        iceString = title!
        print(title!)
    }
    
    @IBAction func add(_ sender: UISwitch) {
        
        if sender.isOn {
            addFeed = 10
            addLabel.text = "+10"
            feedString = "是"
           }else {
            addFeed = 0
            addLabel.text = "+0"
            feedString = "否"
           }
        calculate()
    }
    
    
    @IBAction func qty(_ sender: UIStepper) {
        //取得stepper的值
        drinkQty = Int(qtyStepper.value)
        //並顯示在label中
        qtyLabel.text = "\(drinkQty ?? orderDetial.qty)"
        //計算總金額（看下一段了解）
        calculate()
    }
    
    //將所有Stepper的 值＊金額加總
    func calculate() {
        if(drinkQty != 0){
            let sum = drinkQty * orderDetial.price + addFeed * drinkQty
            //將金額顯示於totalLabel
            total.text = "總金額 ： \(sum)"
            totalString = sum
        }else{
            total.text = "總金額 ： 0"
            totalString = 0
        }
        
      
    }
    @IBAction func submit(_ sender: Any) {
        //修改訂單
        if drinkQty > 0 {
            let post = ["user": orderDetial.user,
                        "order_name": orderDetial.order_name,
                        "menu": orderDetial.menu,
                        "price": orderDetial.price,
                        "ice": iceString as Any,
                        "size": orderDetial.size,
                        "sweet": sweet.text as Any,
                        "qty": drinkQty as Any,
                        "feed": feedString as Any,
                        "total": totalString as Any,
                        "remarks": remarks.text as Any,
                        "key": orderDetial.key] as [String : Any]
            db.child(orderDetial.key).setValue(post) {
              (error:Error?, ref:DatabaseReference) in
              if let error = error {
                print("Data could not be saved: \(error).")
              } else {
                self.alert(title: "成功",message: "修改成功")
              }
            }
        }else{
            self.alert(title: "錯誤",message: "數量不能為0")
        }
    
    }
    
    func alert(title:String,message:String) {
        // 建立一個提示框
        let alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
            if self.drinkQty > 0{
                self.navigationController?.popViewController(animated: true)
            }
           
            }
        alertController.addAction(okAction)

        // 顯示提示框
        self.present(alertController,animated: true,completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Database.database().reference(withPath: "orderReviews")
       
        user.text = "帳號：\(orderDetial.user)"
        order_name.text = "訂購人 ：\(orderDetial.order_name)"
        menuLabel.text = "品項： \(orderDetial.menu)"
        price.text = "\(orderDetial.price)"
        sweet.text = orderDetial.sweet
        qtyLabel.text = "\(orderDetial.qty)"
        remarks.text = orderDetial.remarks
        total.text = "總金額 ： \(orderDetial.total)"
        
        drinkQty = orderDetial.qty
        qtyStepper.value = Double(orderDetial.qty)
        iceString = orderDetial.ice
        feedString = orderDetial.feed
        totalString = orderDetial.total
        
        if orderDetial.size == "大"{
            sizeSeg.setEnabled(false, forSegmentAt: 0)
            sizeSeg.selectedSegmentIndex = 1
        }else{
            sizeSeg.setEnabled(false, forSegmentAt: 1)
            sizeSeg.selectedSegmentIndex = 0
        }


        if orderDetial.ice == "去冰"{
            iceSeg.selectedSegmentIndex = 0
        }else if orderDetial.ice == "少冰"{
            iceSeg.selectedSegmentIndex = 1
        }else if orderDetial.ice == "正常"{
            iceSeg.selectedSegmentIndex = 2
        }else {
            iceSeg.selectedSegmentIndex = 3
        }

        if orderDetial.feed == "是"{
            addSwitch.setOn(true, animated: false)
            addLabel.text = "+10"
            addFeed = 10
        }else{
            addSwitch.setOn(false, animated: false)
            addLabel.text = "0"
            addFeed = 0
        }
        
        
        //設定代理人和資料來源為viewController
        picker.delegate = self
        picker.dataSource = self
        //讓textfiled的輸入方式改為PickerView
        sweet.inputView = picker
        
        //加上手勢按鈕
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)

        
    }
    
    @objc func closeKeyboard(){
    self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sweetdata.count

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sweet.text = sweetdata[row]
        sweetString =  sweet.text!
    }
    
    //設定每列PickerView要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return sweetdata[row]
    }
}
