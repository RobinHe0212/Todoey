//
//  ViewController.swift
//  Todoey
//
//  Created by Robin He on 10/11/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items=[Items]()
   //var items=["find Mike","play PS4","buy eggs"]
    let defaults=UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let newItem=Items()
        newItem.title="find Mike"
        items.append(newItem)
        
        let newItem1=Items()
        newItem1.title="play PS4"
        items.append(newItem1)
        
        let newItem2=Items()
        newItem2.title="buy eggs"
        items.append(newItem2)
        
        let newItem3=Items()
        newItem3.title="play basketball"
        items.append(newItem3)
        
                if let itemsArray = defaults.array(forKey: "TodoList") as? [Items] {
                    items=itemsArray
                }
    }
    //Mark -Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text=items[indexPath.row].title
        
        cell.accessoryType=items[indexPath.row].done ? .checkmark : .none
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //Mark-Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        items[indexPath.row].done = !items[indexPath.row].done
    
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

   
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var text=UITextField()
        let alert=UIAlertController(title: "Add Items", message: "", preferredStyle: .alert)
       let aLertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            print(text.text!)
            let new=Items()
            new.title=text.text!
            self.items.append(new)
        
            self.defaults.set(self.items, forKey: "TodoList")
            self.tableView.reloadData()
        }
        alert.addTextField { (textAlertField) in
            textAlertField.placeholder="create an item"
            text=textAlertField
            print("ready to write")
        }
        alert.addAction(aLertAction)
        present(alert,animated: true,completion: nil)
        
    }
}

