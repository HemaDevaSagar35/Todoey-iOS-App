//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import Hue
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray : Results<Item>?
    let realm = try! Realm()
    var selectCategory : Categorie?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectCategory?.colorValue{
            
            title = selectCategory!.name
            guard let navBar = navigationController?.navigationBar else {fatalError("NavBar isn't initialized")}

            let navBarColor = UIColor(hex: colorHex)

            navBar.standardAppearance.backgroundColor = navBarColor
            navBar.scrollEdgeAppearance?.backgroundColor = navBarColor

//            navBar.barTintColor = navBarColor
            navBar.tintColor = navBarColor.isDark ? UIColor.white : UIColor.darkGray
            
            navBar.scrollEdgeAppearance?.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : navBarColor.isDark ? UIColor.white : UIColor.darkGray]
            navBar.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : navBarColor.isDark ? UIColor.white : UIColor.darkGray]
            
            addButton.tintColor = navBarColor.isDark ? UIColor.white : UIColor.darkGray

            searchBar.barTintColor = navBarColor
            searchBar.searchTextField.backgroundColor = .white

        }
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
            let desaturatedBlue = UIColor(hex: selectCategory?.colorValue ?? "#009CDA")
            
            let setValue = CGFloat(indexPath.row) / CGFloat(itemArray!.count)
//            print(setValue)
            let saturatedBlue = desaturatedBlue.add(hue: 1.0, saturation: 0.2, brightness: -(0.5*setValue), alpha: 0.0)
            cell.backgroundColor = saturatedBlue
            
            cell.textLabel?.textColor = saturatedBlue.isDark ? UIColor.white : UIColor.darkGray
            
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
