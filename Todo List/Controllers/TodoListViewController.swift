//
//  ViewController.swift
//  Todo List
//
//  Created by Brinit on 12/08/25.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
// MARK:- Assigning Variables
    var listItems = [Item]()
//MARK:- Assigning Path of Database and Classes
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
// File Path Of The Application Files
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("\(String(describing: dataFilePath))")
        
        
        loadItems()
        //MARK:- TableView DataSource Methods
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = listItems[indexPath.row]
        cell.textLabel?.text = item.title
      
//        (!item.done) ? (cell.accessoryType = .none) : (cell.accessoryType = .checkmark)
        
        cell.accessoryType = item.done ? .checkmark : .none
        
       
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var checkTitle = "Uncheck"
        var myupdatedTextField = UITextField()
    //MARk:- Items That updte the DataBase
        let title = listItems[indexPath.row].title
        let updateList = UIAlertController(title: "Update List Items", message: title , preferredStyle: .actionSheet)
        
        let doneAction = UIAlertAction(title: "Update Item", style: .default) { action in
            let updateAlert = UIAlertController(title: "Update Title", message: title, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "Update", style: .default) { action in
                if myupdatedTextField.text != nil && myupdatedTextField.text != "" {
                    self.listItems[indexPath.row].title = myupdatedTextField.text
                    self.saveItems()
                }
               
                self.tableView.reloadData()
            }
            updateAlert.addTextField {updateTextField in
                updateTextField.placeholder = "Enter Text "
                myupdatedTextField = updateTextField
            }
            updateAlert.addAction(updateAction)
            self.present(updateAlert, animated: true)
        }
    //MARk:- Items That Check Uncheck the item in the DataBase
        (self.listItems[indexPath.row].done) ? (checkTitle = "Uncheck") : (checkTitle = "Check")
        
        let checkAction = UIAlertAction(title: checkTitle, style: .default) { action in
           
            self.listItems[indexPath.row].done = !self.listItems[indexPath.row].done
            self.saveItems()
            self.tableView.reloadData()
        }
    //MARk:- Items That Remove the item in the DataBase
        let removeAction = UIAlertAction(title: "Remove Item", style: .destructive) { _ in
            let removeAlert = UIAlertController(title: "Remove Item", message: "Are you Want to Remove Data", preferredStyle: .alert)
            let YesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                self.context.delete(self.listItems[indexPath.row])
                self.listItems.remove(at: indexPath.row)
                self.saveItems()
                self.tableView.reloadData()
            }
            let NoAction = UIAlertAction(title: "No", style: .default)
            removeAlert.addAction(YesAction)
            removeAlert.addAction(NoAction)
            self.present(removeAlert, animated: true)
        }
        updateList.addAction(doneAction)
        updateList.addAction(checkAction)
        updateList.addAction(removeAction)
      present(updateList, animated: true)
        
            
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

        //MARK:- Add new Items
        
        @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
            var addItemTextField = UITextField()
            
            let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
                // What Happen if User Taped On Add on our UIAlert
                if let textAvailable = addItemTextField.text{
                    if  textAvailable != ""{
                       
                        let item = Item(context:self.context)
                            item.title =  addItemTextField.text!
                            item.done = false
                        self.listItems.append(item)
                        saveItems()
                    }
                }
            }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                addItemTextField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true)
        }

// MARK:- Save Item into DataBase
    func saveItems(){
        
        
        do {
            try context.save()
        }catch {
            print("Error Saving Context \(error)")}
        self.tableView.reloadData()
    }
// MARK:- Fetch Item from the DataBase
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
           listItems =  try context.fetch(request)
        }
        catch{
            print("Error Fetching Request form context \(error)")
        }
        tableView.reloadData()
    }
    
    
}
//MARK:- Search Configrations
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Find Items using SearchBar
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
    }
        // Back to the ItemList after search Over
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
