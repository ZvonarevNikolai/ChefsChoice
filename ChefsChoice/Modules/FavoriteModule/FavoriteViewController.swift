//
//  FavoriteViewController.swift
//  ChefsChoice
//
//  Created by Дмитрий on 28.02.2023.
//

import UIKit

struct testModel {
    let title: String
    let time: Int
    let image: UIImage
}

class FavoriteViewController: UITableViewController {
    
    var model: [testModel] = [
        testModel(title: "Cannellini Bean and Asparagus Salad with Mushrooms", time: 25, image: UIImage(systemName: "birthday.cake") ?? UIImage()),
        testModel(title: "Red Lentil Soup with Chicken and Turnips", time: 22, image: UIImage(systemName: "birthday.cake.fill") ?? UIImage()),
        testModel(title: "Slow Cooker Beef Stew", time: 45, image: UIImage(systemName: "carrot.fill") ?? UIImage()),
        testModel(title: "Chicken Fajita Stuffed Bell Pepper", time: 125, image: UIImage(systemName: "cup.and.saucer.fill") ?? UIImage()),
        testModel(title: "Hummus and Za'atar", time: 7, image: UIImage(systemName: "takeoutbag.and.cup.and.straw") ?? UIImage()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CellForFavorite.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellForFavorite
        let myModel = model[indexPath.row]
        cell?.configureTest(myModel)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
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
