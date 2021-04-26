//
//  ViewController.swift
//  demoDrink
//
//  Created by YA on 2021/4/23.
//

import UIKit




class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func login(_ sender: Any) {
        if(nameTextField.text != ""){
            UserDefaults.standard.setValue(nameTextField.text, forKey: "userAccount")
            if  let vc = storyboard?.instantiateViewController(identifier: "tab"){
                self.present(vc,animated: true,completion: nil)
            }
        }else{
            alert()
        }
    }
    
    func alert() {
        // 建立一個提示框
        let alertController = UIAlertController(title: "錯誤",message: "請輸入帳號",preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "確認",style: .default,handler: nil)
        alertController.addAction(okAction)
        // 顯示提示框
        self.present(alertController,animated: true,completion: nil)
    }
    

    

}

