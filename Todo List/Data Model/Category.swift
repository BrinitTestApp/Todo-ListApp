//
//  Category.swift
//  Todo List
//
//  Created by Brinit on 21/08/25.
//

import Foundation
import RealmSwift

class Category: Object{
    
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
}
