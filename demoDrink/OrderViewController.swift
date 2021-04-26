//
//  OrderViewController.swift
//  demoDrink
//
//  Created by YA on 2021/4/24.
//

import UIKit
import Firebase

class OrderViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    //data是PickerView的內容
    var sweetdata = ["無糖(0%)","一分糖(10%)","二分糖(20%)","微糖(30%)","半糖(50%)","少糖(70%)","正常糖(100%)"]
    //產生PickerView
    var picker = UIPickerView()
   
    var drinkQty:Int = 0
    
    var price:Int = 0
    var addFeed:Int = 0
    var size:String = "中"
    var iceString:String = "去冰"
    var sweetString = "無糖(0%)"
    var totalString:Int = 0
    var feedString:String = "否"
    
    @IBOutlet weak var order_name: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sweet: UITextField!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var sizeSeg: UISegmentedControl!
    @IBOutlet weak var iceSeg: UISegmentedControl!
    @IBOutlet weak var addSwitch: UISwitch!
    @IBOutlet weak var qtyStepper: UIStepper!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var remarks: UITextView!
   
    
    let userAccount = UserDefaults.standard.string(forKey: "userAccount")
    let menu: Menu
    
    init?(coder: NSCoder, menu: Menu) {
        self.menu = menu
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func size(_ sender: Any) {
        let title = sizeSeg.titleForSegment(at: sizeSeg.selectedSegmentIndex)
    
        if title == "大"{
            priceLabel.text = "\(self.menu.priceL ?? 0)"
            price = menu.priceL ?? 0
            size = "大"
        }else{
            priceLabel.text = "\(self.menu.priceM)"
            price = menu.priceM
            size = "中"
        }
        calculate()
    }
    
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
        qtyLabel.text = "\(drinkQty)"
        //計算總金額（看下一段了解）
        calculate()
    }
    
    //將所有Stepper的 值＊金額加總
    func calculate() {
        if(drinkQty != 0){
            let sum = drinkQty * price + addFeed * drinkQty
            //將金額顯示於totalLabel
              totalPrice.text = "總金額 ： \(sum)"
            totalString = sum
        }else{
            totalPrice.text = "總金額 ： 0"
            totalString = 0
        }
        
      
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if totalString != 0 , order_name.text != ""{
            // 新增節點資料
            let reference: DatabaseReference! = Database.database().reference().child("orderReviews")
            let childRef: DatabaseReference = reference.childByAutoId() // 隨機生成的節點唯一識別碼，用來當儲存時的key值
            var orderReview: [String : AnyObject] = [String : AnyObject]()
                orderReview["menu"] = menu.name as AnyObject
                orderReview["size"] = size as AnyObject
                orderReview["price"] = price as AnyObject
                orderReview["sweet"] = sweetString as AnyObject
                orderReview["ice"] = iceString as AnyObject
                orderReview["feed"] = feedString as AnyObject
                orderReview["qty"] = drinkQty as AnyObject
                orderReview["remarks"] = remarks.text as AnyObject
                orderReview["total"] = totalString as AnyObject
                orderReview["user"] = userAccount as AnyObject
                orderReview["key"] = childRef.key as AnyObject
                orderReview["order_name"] = order_name.text as AnyObject
               
                    
            let orderReviewReference = reference.child(childRef.key!)
            orderReviewReference.updateChildValues(orderReview) { (err, ref) in
                        if err != nil{
                            print("err： \(err!)")
                            return
                        }
                self.alert(title: "成功",message: "下單成功")
                        print(ref.description())
                      
                    }
        }else{
            self.alert(title: "錯誤",message: "數量不可為0\n或訂購人姓名未填")
        }
        
    }
    
    func alert(title:String,message:String) {
        // 建立一個提示框
        let alertController = UIAlertController(title: title,message: message,preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "確認", style: .default) { (_) in
            
            self.navigationController?.popViewController(animated: true)
            }
        alertController.addAction(okAction)
        // 顯示提示框
        self.present(alertController,animated: true,completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sweet.text = sweetdata[0]
        remarks.layer.borderColor = UIColor.black.cgColor
        remarks.layer.borderWidth = 1
        
        name.text = menu.name
        priceLabel.text = "\(menu.priceM)"
        price = menu.priceM
        
        
        //設定代理人和資料來源為viewController
        picker.delegate = self
        picker.dataSource = self
        //讓textfiled的輸入方式改為PickerView
        sweet.inputView = picker
        
        //加上手勢按鈕
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        
        print(menu.priceL as Any)
        if menu.priceL == nil{
            sizeSeg.setEnabled(false, forSegmentAt: 1)
        }

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
