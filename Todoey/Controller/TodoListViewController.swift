//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let fileDirecotory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchBar.delegate = self
        loadData()
    }
    
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
//        print("happening")
        cell.textLabel?.text = itemArray[indexPath.row].title
        let checked = itemArray[indexPath.row].checked
        
        cell.accessoryType = checked ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) is selected")
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].checked = !itemArray[indexPath.row].checked
        
        updateState()
        
        tableView.reloadData()

    }
    
    // Add item
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Todo item dude", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default){action in
            print("success")
            let item = Item(context: self.context)
            item.title = textField.text!
            item.checked = false
            
            self.itemArray.append(item)
            self.updateState()
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField(){alertText in
            
            alertText.placeholder = "Create new item"
            textField = alertText
            
        }
        
        present(alert, animated: true)
    }
    
    func updateState(){
//        let encode = PropertyListEncoder()
        do{
            try context.save()
        }catch{
            print("Error occured \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()){
       
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error occured while loading \(error)")
        }
        self.tableView.reloadData()
    }

}

//MARK: - SearchBar
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadData(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            loadData()
        }
        
    }
}
