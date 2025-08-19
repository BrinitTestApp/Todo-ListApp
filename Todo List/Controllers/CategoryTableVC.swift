//
//  CategoryTableVC.swift
//  Todo List
//
//  Created by Brinit on 18/08/25.
//

import UIKit
import CoreData
class CategoryTableVC: UITableViewController {
//MARK:- Adding Variable
    var categoryName = [Category]()

//MARK:- Adding Appdelegate path
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
      
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryName.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CetagoryCell", for: indexPath)
        cell.textLabel?.text = categoryName[indexPath.row].name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Go to Lists", message: "", preferredStyle: .alert)
        let ListAction = UIAlertAction(title: "List", style: .default) { _ in
            self.performSegue(withIdentifier: "ListtoItem", sender: self)
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: "Delete Recored", message: "Are you Want to Delete Record", preferredStyle: .alert)
            let deleteYes = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.context.delete(self.categoryName[indexPath.row])
                self.categoryName.remove(at: indexPath.row)
                self.saveData()
                self.tableView.reloadData()
            }
            let deleteNo = UIAlertAction(title: "No", style: .default)
            deleteAlert.addAction(deleteNo)
            deleteAlert.addAction(deleteYes)
            self.present(deleteAlert, animated: true)
        }
        alert.addAction(ListAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
     
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
    
        if let indexpath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = categoryName[indexpath.row] 
        }
    }
    
    
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let categoryAc = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let categoryAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            if categoryTextField.text != nil && categoryTextField.text != ""{
                let item = Category(context: self.context)
                item.name = categoryTextField.text
                self.categoryName.append(item)
                self.saveData()
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
    
    func saveData(){
        do{
            try context.save()
        }catch{
            print("Error Saving Data \(error)")
        }
        tableView.reloadData()
    }
    func loadData(){
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
           categoryName =  try context.fetch(request)
        }catch{
            print("Error Load Data \(error)")
        }
        tableView.reloadData()
    }
}
