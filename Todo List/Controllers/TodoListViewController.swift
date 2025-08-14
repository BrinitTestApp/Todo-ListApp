//
//  ViewController.swift
//  Todo List
//
//  Created by Brinit on 12/08/25.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    
    var listItems = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        print(dataFilePath)
        let item1 = Item()
        item1.title = "Milk"
        listItems.append(item1)
        
        let item2 = Item()
        item2.title = "Cake"
        listItems.append(item2)
        
        let item3 = Item()
        item3.title = "Bread"
   
        listItems.append(item3)
        
        loadItems()
        
    }
    
    //MARK:- TableView DataSource Methods
    
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
        
        listItems[indexPath.row].done = !listItems[indexPath.row].done
        saveItems()
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
                        let item = Item()
                        item.title =  addItemTextField.text!
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

    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(listItems)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error encoding item array . \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                listItems = try decoder.decode([Item].self, from: data)
                
            }catch{
                print("Error Decode Item \(error)")
            }
        }
    }
    
    
}
