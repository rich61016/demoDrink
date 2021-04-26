//
//  HomeViewController.swift
//  demoDrink
//
//  Created by YA on 2021/4/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var images = [UIImage]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 0...3 {
            images.append(UIImage(named: "Image\(i)")!)
                }
        
        imageView.animationImages = images
        imageView.animationDuration = 5
        imageView.startAnimating()
    }
    
    
    @IBAction func log_out(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userAccount")
        let mainStoreboard = UIStoryboard(name: "Main", bundle: nil)
        let DVC = mainStoreboard.instantiateViewController(withIdentifier: "ViewController")
        present(DVC, animated: true,completion: nil)
    }
    


}
