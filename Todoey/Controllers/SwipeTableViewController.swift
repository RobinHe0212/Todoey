//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Robin He on 10/17/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController : UITableViewController ,SwipeTableViewCellDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //tableview datasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate=self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else{return nil}
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
                    self.update(at: indexPath)

            
        }
        
        deleteAction.image=UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
    func update(at indexPath:IndexPath){
    }

    
}
