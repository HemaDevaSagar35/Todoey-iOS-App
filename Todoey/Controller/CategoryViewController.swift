//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hema Deva Sagar Potala on 8/28/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {

    var categoriesArray : Results<Categorie>?
    
    let realm = try! Realm()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
//        cell.delegate = self
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoriesArray?[indexPath.row].name ?? "Not yet added any items"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = categoriesArray?[indexPath.row]
        }
    }
    
    // MARK: - Add New category
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        
        let action = UIAlertAction(title: "Add Category", style: .default){action in
            
            let cat = Categorie()
            cat.name = textField.text!
            
            self.updateCategory(cat: cat)
        }
        
        alert.addAction(action)
        
        alert.addTextField(){alertTextField in
            
            alertTextField.placeholder = "New category"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Data Manipulation
    
    func updateCategory(cat : Categorie){
        do{
            try realm.write({
                realm.add(cat)
            })
        }catch{
            print("Error occured while save the category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func loadData(){
        categoriesArray = realm.objects(Categorie.self)
    }
    
    override func updateModel(at: IndexPath) {
        
        if let catego = self.categoriesArray?[at.row]{
            do{
                try self.realm.write({
                    self.realm.delete(catego)
                })
            }catch{
                print("Issue occured while deleting : \(error)")
            }
        }

    }
    

}



