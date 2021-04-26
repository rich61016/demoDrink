//
//  MenuTableViewController.swift
//  demoDrink
//
//  Created by YA on 2021/4/24.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseDatabase

class MenuTableViewController: UITableViewController {
    
    var db: DatabaseReference!
    var menuReviews: [Menu] = [Menu]()
    @IBOutlet var menutableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Database.database().reference(withPath: "results")

        db.queryOrderedByKey().observe(.value, with: { snapshot in
                    if snapshot.childrenCount > 0 {
                        var dataList: [Menu] = [Menu]()
                        
                        for item in snapshot.children {
                            let data = Menu(snapshot: item as! DataSnapshot)
                            dataList.append(data)
                        }
                        
                        self.menuReviews = dataList
                        self.menutableView.reloadData()
                    }
                    
                })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuReviews.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell

        cell.nameLabel.text = self.menuReviews[indexPath.row].name
        cell.priceMLabel.text =   "中  :  \(self.menuReviews[indexPath.row].priceM)"
        if  menuReviews[indexPath.row].priceL != nil{
            cell.priceLLabel?.text =  "大  :  \(self.menuReviews[indexPath.row].priceL ?? 0)"
        }else{
            cell.priceLLabel?.text = nil
        }
        cell.descriptionLabel.text = self.menuReviews[indexPath.row].description
        

        return cell
    }
    
    @IBSegueAction func order(_ coder: NSCoder) -> OrderViewController? {
        guard let row = tableView.indexPathForSelectedRow?.row else { return nil }
        return OrderViewController(coder: coder, menu: menuReviews[row])
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
