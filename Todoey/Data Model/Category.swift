//
//  Category.swift
//  Todoey
//
//  Created by Robin He on 10/16/18.
//  Copyright © 2018 Robin He. All rights reserved.
//

import Foundation
import RealmSwift
class Category : Object{
    
  @objc dynamic var name:String=""
  @objc dynamic var color:String=""
    var items=List<Item>()
}
