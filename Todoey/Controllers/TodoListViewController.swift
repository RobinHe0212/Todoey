//
//  ViewController.swift
//  Todoey
//
//  Created by Robin He on 10/11/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    
    var items=[Items]()
   //var items=["find Mike","play PS4","buy eggs"]
//    let defaults=UserDefaults.standard
    
    var selectedCategory:Category?{
        didSet{
            
            loadItems()
        }
        
    }
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

       let dataFilePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(dataFilePath)
//                if let itemsArray = defaults.array(forKey: "TodoList") as? [Items] {
//                    items=itemsArray
//                }
       
        
        
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
        
        let new = Items(context: self.context)
            new.title=text.text!
            new.done=false
            new.parentCategory=self.selectedCategory
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
        
        do{
          try
            context.save()
        }catch{
            
            print("Error encoding,\(error) ")
            
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Items> = Items.fetchRequest(),predicator :NSPredicate?=nil){
        
        let categoryPredicator=NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredictor = predicator{
            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicator,additionalPredictor])
            
        }else{
            
            request.predicate=categoryPredicator
        }
       
        do{
        items=try context.fetch(request)
        }catch{
            print("Fetch data error \(error)")
        }
        
        tableView.reloadData()
        
        
//        if let data=try? Data(contentsOf: dataFilePath!){
//        let decode=PropertyListDecoder()
//
//        do{
//        items=try decode.decode([Items].self, from: data)
//
//        }catch{
//            print("Error is \(error)")
//
//        }
//    }
    }
    

    
}
extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Items> = Items.fetchRequest()
        request.predicate=NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
       loadItems(with: request,predicator: request.predicate)
        
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
