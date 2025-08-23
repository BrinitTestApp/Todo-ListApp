//
//  CategoryTableVC.swift
//  Todo List
//
//  Created by Brinit on 18/08/25.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryTableVC: UITableViewController{
   
    
//MARK:- Adding Variable
    let realm = try! Realm()
    
    var categoryName: Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        tableView.rowHeight = 60.0
        
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryName?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CetagoryCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        cell.textLabel?.text = categoryName?[indexPath.row].name ?? "No Data Found"
        cell.delegate = self
        return cell
        }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
      
            self.performSegue(withIdentifier: "ListtoItem", sender: self)

     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
    
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = categoryName?[indexpath.row] 
        }
    }
    
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let categoryAc = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let categoryAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            if categoryTextField.text != nil && categoryTextField.text != ""{
                let item = Category()
                item.name = categoryTextField.text!
                self.saveData(catagory: item)
            }else{
                return
            }
           
            
        }
        categoryAc.addTextField { textField in
            textField.placeholder = "add category to your list"
            categoryTextField = textField
        }
        categoryAc.addAction(categoryAction)
        present(categoryAc, animated: true)
        tableView.reloadData()
    }
    
//MARK: - Data Maniplation Methods
    
    func saveData(catagory: Category){
        do{
            try realm.write{
                realm.add(catagory)
            }
        }catch{
            print("Error Saving Data \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteData(catagory: Category){
        do{
            try realm.write{
                realm.delete(catagory)
            }
        }catch{
            print("Error Deleing Data \(error)")
        }
        tableView.reloadData()
    }
        
    
            
        
    func loadData(){
        
        categoryName = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            CellAnimation.animate(cell,withDuration: 1)
        }

}
//MARK: - Swipe TableView Configrations
extension CategoryTableVC: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard  orientation == .right else {return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            guard let myItem = self.categoryName?[indexPath.row] else {return}
            let deleteAlert = UIAlertController(title: "Delete Recored", message: "Are you Want to Delete Record", preferredStyle: .alert)
            let deleteYes = UIAlertAction(title: "Yes", style: .destructive) { _ in
                do{
                    try self.realm.write{
                        self.realm.delete(myItem.items)
                        self.realm.delete(myItem)
                    }
                }catch{
                    print("Error Deleting Data\(error)")
                }
               
                
                self.tableView.reloadData()
                
            }
            let deleteNo = UIAlertAction(title: "No", style: .default)
            deleteAlert.addAction(deleteNo)
            deleteAlert.addAction(deleteYes)
            self.present(deleteAlert, animated: true)
            print("Delete")
            
      
            // handle action by updating model with deletion
            self.tableView.reloadData()
        }
        deleteAction.image = UIImage(systemName: "trash")
        // customize the action appearance
        
        return [deleteAction]
        
    }
}
