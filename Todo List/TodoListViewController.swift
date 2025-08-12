//
//  ViewController.swift
//  Todo List
//
//  Created by Brinit on 12/08/25.
//

import UIKit

class TodoListViewController: UITableViewController {

    
    var listItems = ["pizza","Breads","Milk"]
    let defaults = UserDefaults.standard
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let item = defaults.array(forKey: "TodoList item") as? [String]{
            listItems = item
        }
      
      
    }

    //MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row]
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
      
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add new Items
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var addItemTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New TodoList Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What Happen if User Taped On Add on our UIAlert
            if let textAvailable = addItemTextField.text{
                if  textAvailable != "" {
                    self.listItems.append(addItemTextField.text!)
                    self.defaults.set(self.listItems, forKey: "TodoList item")
                }
            }
            
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            addItemTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
}

