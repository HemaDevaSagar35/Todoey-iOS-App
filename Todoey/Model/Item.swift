//
//  Item.swift
//  Todoey
//
//  Created by Hema Deva Sagar Potala on 8/31/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var checked : Bool = false
    @objc dynamic var created : Date?
    
    let parentCategory = LinkingObjects(fromType: Categorie.self, property: "items")
    
}
