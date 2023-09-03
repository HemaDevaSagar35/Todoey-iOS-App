//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var itemArray : Results<Item>?
    let realm = try! Realm()
    var selectCategory : Categorie?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Yes this is awesome")
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        print("happening")
        if let item = itemArray?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
            
        }else{
           
            cell.textLabel?.text = "No Item Added yet!"
        }
        
        
        return cell
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write({
                    item.checked = !item.checked
                })
            }catch{
                print("Error occurred while trying to update the item checked states \(error)")
            }
        }
        tableView.reloadData()

    }
    
    // Add item
    //MARK: - add Item functionality
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todo item dude", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){action in
            print("success")
            
            if let currentCategory = self.selectCategory{
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.created = Date()
                        currentCategory.items.append(item)
                    }
                }catch{
                    print("Error happend when saving the update: \(error)")
                }
                
            }
//            self.loadData()
            self.tableView.reloadData()
        }

        alert.addAction(action)

        alert.addTextField(){alertText in

            alertText.placeholder = "Create new item"
            textField = alertText

        }

        present(alert, animated: true)
    }
    
    //MARK: - data manipulation

    func loadItems(){

        itemArray = selectCategory?.items.sorted(byKeyPath: "created", ascending: true)
        self.tableView.reloadData()
        
    }
    
    override func updateModel(at: IndexPath) {
        if let item = itemArray?[at.row]{
            do{
                try self.realm.write({
                    self.realm.delete(item)
                })
            }catch{
                print("Issue occured while deleting : \(error)")
            }
        }
    }

}

//MARK: - SearchBar
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "created", ascending: true)
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

            loadItems()
        }
        
    }
}
