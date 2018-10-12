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
//    let defaults=UserDefaults.standard
    
    let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print(dataFilePath!)
//                if let itemsArray = defaults.array(forKey: "TodoList") as? [Items] {
//                    items=itemsArray
//                }
       
        loadItems()
        
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
    
        saveData()
        
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
        
//            self.defaults.set(self.items, forKey: "TodoList")
        self.saveData()
        
        }
        alert.addTextField { (textAlertField) in
            textAlertField.placeholder="create an item"
            text=textAlertField
            print("ready to write")
        }
        alert.addAction(aLertAction)
        present(alert,animated: true,completion: nil)
        
    }
    
    func saveData(){
        let encoder=PropertyListEncoder()
        
        do{
            
            let data = try encoder.encode(items)
            try data.write(to:dataFilePath!)
            
            
            
        }catch{
            
            print("Error encoding,\(error) ")
            
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data=try? Data(contentsOf: dataFilePath!){
        let decode=PropertyListDecoder()
        
        do{
        items=try decode.decode([Items].self, from: data)
           
        }catch{
            print("Error is \(error)")
            
        }
    }
    }
}

