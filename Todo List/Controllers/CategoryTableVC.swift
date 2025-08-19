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
        performSegue(withIdentifier: "ListtoItem", sender: self)
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
