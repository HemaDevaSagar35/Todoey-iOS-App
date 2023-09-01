//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hema Deva Sagar Potala on 8/28/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Categorie]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectCategory = categoriesArray[indexPath.row]
        }
    }
    
    // MARK: - Add New category
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){action in
            print("success")
            print(textField.text!)
            // Add to the categorie
            let cat = Categorie(context: self.context)
            cat.name = textField.text!
            self.categoriesArray.append(cat)
            
            self.updateCategory()
        }
        
        alert.addAction(action)
        
        alert.addTextField(){alertTextField in
            
            alertTextField.placeholder = "New category"
            textField = alertTextField
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Data Manipulation
    
    func updateCategory(){
        do{
            try context.save()
        }catch{
            print("Error occured while save the category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Load Data
    
    func loadData(with request : NSFetchRequest<Categorie> = Categorie.fetchRequest()){
        do{
            categoriesArray = try context.fetch(request)
        }catch{
            print("Error occured while loading the categories: \(error)")
        }
    }
    

}
