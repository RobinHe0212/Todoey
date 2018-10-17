//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Robin He on 10/12/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm=try!Realm()
    var categoryList : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    //Table view for data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoCategoryCell", for: indexPath)
        cell.textLabel?.text = categoryList?[indexPath.row].name ?? "No Category added"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    //Table view for delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination=segue.destination as! TodoListViewController
       if let indexPath=tableView.indexPathForSelectedRow{
            
            destination.selectedCategory=categoryList?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var text=UITextField()
        let alert=UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        let alertAction=UIAlertAction(title: "Add", style: .default) { (action) in
            //Todo set value in the datamodel and save data
            print("alertaction \(text.text!)")
            let newCategory=Category()
            newCategory.name=text.text!
          
            self.save(category: newCategory)
            print(self.categoryList?.count ?? 1)
        }
        
        
        
        alert.addTextField { (textField) in
            textField.placeholder = "create a new category"
            text=textField
            print("Ready to write ")
        }
        alert.addAction(alertAction)
        present(alert,animated: true,completion: nil)
    }
    
    
    func save(category:Category){
        do{
        try
            realm.write {
                realm.add(category)
            }
        }catch{
            print("Save data error \(error)")
            
        }
        tableView.reloadData()
    }
    
    //load data
    func loadItems(){

       categoryList=realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
}
extension CategoryTableViewController : UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request:NSFetchRequest<Category>=Category.fetchRequest()
//        request.predicate=NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors=[NSSortDescriptor(key: "name", ascending: true)]
//        loadItems(with: request)
//    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}
