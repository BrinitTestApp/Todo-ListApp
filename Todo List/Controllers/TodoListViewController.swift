//
//  ViewController.swift
//  Todo List
//
//  Created by Brinit on 12/08/25.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
// MARK: - Assigning Variables
    let realm = try! Realm()
    var listItems: Results<Item>?
    var selectedCatagory: Category?{
        didSet{
            loadItems()
        }
    }
    
//MARK: - Assigning Path of Database and Classes
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
// File Path Of The Application Files
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print("\(String(describing: dataFilePath))")
        
        
      
        //MARK:  - TableView DataSource Methods
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "TodoItemCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = listItems?[indexPath.row]{
            cell.textLabel?.text = item.title
          
    //        (!item.done) ? (cell.accessoryType = .none) : (cell.accessoryType = .checkmark)
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text  = "No Items Added"
        }
       
        
       
        return cell
    }
    
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var checkTitle = "Uncheck"
        var myupdatedTextField = UITextField()
        guard let myitem = listItems?[indexPath.row]else {return}
        
        
    //MARK: - Items That updte the DataBase
        let title = listItems?[indexPath.row].title
        let updateList = UIAlertController(title: "Update List Items", message: title , preferredStyle: .actionSheet)
        
        let doneAction = UIAlertAction(title: "Update Item", style: .default) { action in
            let updateAlert = UIAlertController(title: "Update Item", message: title, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "Update", style: .default) { action in
                if myupdatedTextField.text != nil && myupdatedTextField.text != "" {
                    do{
                        try self.realm.write{
                            myitem.title = myupdatedTextField.text!
                            
                        }
                    }catch{
                        print("Error updating Title \(error)")
                    }
                    self.tableView.reloadData()
                    
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
    //MARK: - Items That Check Uncheck the item in the DataBase
        (myitem.done) ? (checkTitle = "Uncheck") : (checkTitle = "Check")
        
        let checkAction = UIAlertAction(title: checkTitle, style: .default) { action in
            do{
                try self.realm.write{
                    myitem.done = !myitem.done
            }
            
            }catch{
                print("Error Updating Data \(error)")
            }
           
          
            self.tableView.reloadData()
        }
    //MARK: - Items That Remove the item in the DataBase
        let removeAction = UIAlertAction(title: "Remove Item", style: .destructive) { _ in
            let removeAlert = UIAlertController(title: "Remove Item", message: "Are you Want to Remove Data", preferredStyle: .alert)
            let YesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
                do{
                    try self.realm.write{
                        self.realm.delete(myitem)
                    }
                }catch{
                        print("Error Deleting Data\(error)")
                    }

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

        //MARK: - Add new Items
        
        @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
            var addItemTextField = UITextField()
            
            let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add Item", style: .default) { _ in
                // What Happen if User Taped On Add on our UIAlert
                if let textAvailable = addItemTextField.text{
                    if  textAvailable != ""{
                        if let currentCategory = self.selectedCatagory{
                            do{
                                try self.realm.write{
                                    let item = Item()
                                    item.title =  addItemTextField.text!
                                    item.done = false
                                    item.dateCreated = Date()
                                    currentCategory.items.append(item)
                                }
                            }catch{
                                print("Error Saving Data \(error)")
                            }
                        }
                        
                        self.tableView.reloadData()
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

// MARK: - Save Item into DataBase
    func save(listItem: Item){
        
        
        do {
            try realm.write{
                realm.add(listItem)
            }
        }catch {
            print("Error Saving Context \(error)")}
        self.tableView.reloadData()
    }
// MARK: - Fetch Item from the DataBase
    func loadItems(){
        
        
        listItems = selectedCatagory?.items.sorted(byKeyPath: "title", ascending: true)
//        let Catagorypredicate = NSPredicate(format: "parentCetegory.name MATCHES %@", selectedCatagory!.name!)
//        if let additionalPradicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [Catagorypredicate,additionalPradicate])
//        }else{
//            request.predicate = Catagorypredicate
//        }
//  
//        do{
//           listItems =  try context.fetch(request)
//        }
//        catch{
//            print("Error Fetching Request form context \(error)")
//        }
        tableView.reloadData()
    }
    
    
}
//MARK: - Search Configrations

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Find Items using SearchBar
        
        listItems = listItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadItems(with: request, predicate: predicate)
//
        tableView.reloadData()
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
