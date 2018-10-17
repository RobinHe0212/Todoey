//
//  ViewController.swift
//  Todoey
//
//  Created by Robin He on 10/11/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListViewController: SwipeTableViewController {

    
    
    var items : Results<Item>?
    let realm=try!Realm()
   
    var selectedCategory:Category?{
        didSet{
            
            loadItems()
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(dataFilePath)
        
        tableView.rowHeight=65.0
        tableView.separatorStyle = .none
        
        
    }
    //Mark -Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item=items?[indexPath.row]{
            
            cell.textLabel?.text=item.title
           
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count)){
                
                cell.backgroundColor=color
                 cell.textLabel?.textColor=ContrastColorOf(color, returnFlat: true)
            }
            
            
            cell.accessoryType=item.done ? .checkmark : .none
        }else {
            
            cell.textLabel?.text = "No items added"
        }
       
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    //Mark-Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item=items?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
            }
            }catch{
                print("Saving status error, \(error)")
                
            }
        }
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)
    }

   
    @IBAction func addItems(_ sender: UIBarButtonItem) {
        
        var text=UITextField()
        let alert=UIAlertController(title: "Add Items", message: "", preferredStyle: .alert)
       let aLertAction = UIAlertAction(title: "Add", style: .default) { (action) in
            print(text.text!)
        
        if let currentCategory=self.selectedCategory{
            do{
            try self.realm.write {
                let new = Item()
                new.title=text.text!
                new.dateCreated = Date()
                currentCategory.items.append(new)
            }
            
            
            }catch{
                
                print("Erroe=r saving error , \(error)")
            }
        }
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
    
    
    
    func loadItems(){
        items=selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    
    }
    
    //delete data
    override func update(at indexPath: IndexPath) {
        if let currentItem = items?[indexPath.row]{
        do{
        try realm.write {
            realm.delete(currentItem)
        }
        }catch{
            print("delete error \(error)")
        }
        }
    }
    

    
}
extension TodoListViewController:UISearchBarDelegate{
    
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        items=items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
    
        tableView.reloadData()

  }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
