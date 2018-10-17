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
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        tableView.rowHeight=65.0
        
        tableView.separatorStyle = .none
        if let navbar = navigationController?.navigationBar{
            searchBar.barTintColor = navbar.barTintColor
        }
        
    }

    //Table view for data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currentCategory = categoryList?[indexPath.row]{
            cell.textLabel?.text = currentCategory.name
          guard let cateColor = UIColor(hexString: currentCategory.color) else{fatalError()}
            cell.backgroundColor=cateColor
            cell.textLabel?.textColor=ContrastColorOf(cateColor, returnFlat: true)
            
            
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
        if let des = destination.selectedCategory {
            searchBar.barTintColor=UIColor(hexString: des.color)
            print(searchBar.barTintColor!.hexValue())
        }
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        categoryList=categoryList?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
}

