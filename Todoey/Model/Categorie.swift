//
//  Categorie.swift
//  Todoey
//
//  Created by Hema Deva Sagar Potala on 8/31/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Categorie: Object{
    @objc dynamic var name : String = ""
    @objc dynamic var colorValue : String?
    let items = List<Item>()
}
