//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Robin He on 10/12/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController{

    let realm=try!Realm()
    var categoryList : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        tableView.rowHeight=65.0
        
        tableView.separatorStyle = .none
    }

    //Table view for data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currentCategory = categoryList?[indexPath.row]{
            cell.textLabel?.text = currentCategory.name
            cell.backgroundColor=UIColor(hexString: currentCategory.color )
            
        }
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
           newCategory.color=UIColor.randomFlat.hexValue()
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
    //delete data
    override func update(at indexPath: IndexPath) {
        
        if let categoryForDeletion = categoryList?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            }catch{
                print("delete error ,\(error)")
            }
            
        }

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
//Swipe cell delegate method
//extension CategoryTableViewController:SwipeTableViewCellDelegate{
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else{return nil}
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            
//            if let categoryForDeletion = self.categoryList?[indexPath.row]{
//                do{
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                }catch{
//                    print("delete error ,\(error)")
//                }
//               
//            }
//            
//        }
//        
//        deleteAction.image=UIImage(named: "delete-icon")
//        
//        return [deleteAction]
//    }
//    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeTableOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//    
//    
//    
//}
