//
//  ViewController.swift
//  Todoey
//
//  Created by AbedSabatien on 1/31/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
class TodoListViewController: SwipeTableTableViewController {

    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selecetedCategory : Category? {
        didSet{
           loadItems()
         
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
                

       // if let items = defaults.array(forKey: "ToDoListArray") as? [Items] {
       //   itemsArray = items
       // }

        
        }

    
   

    //MARK - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "no titles yet"
        
        if  todoItems?[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
   
        return cell
        
    }
    
    //MARK : TavleView Delegate methods
    
 

    //MARK : Add new items
    
    
       
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
           
            // What will happen once the user clicks the add new item button
            if let currentCtegory = self.selecetedCategory {
                
                do {
                    try self.realm.write {
                    let NewItem = Item()
                    NewItem.title = textField.text!
                       NewItem.date = Date()
                       
                        
                    currentCtegory.items.append(NewItem)
                        
                        //self.realm.add(NewItem)
                    }}
                    catch {
                    print("error with saving data \(error)")
                    
                }
            }
        self.tableView.reloadData()
          
         
        }
        alert.addTextField { (AlertTextField) in
            
            AlertTextField.placeholder = "Create a new item"
            
            textField = AlertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)

    }
    
   
    
   
    func loadItems () {

        todoItems = selecetedCategory?.items.sorted(byKeyPath: "title")
        
        if todoItems == nil {
        }

        tableView.reloadData()
    }
   
   override func updateCheckingCell(at indexPath : IndexPath) {
        
   // super.updateCheckingCell(at: indexPath)
    
    if let item = todoItems?[indexPath.row] {
        do {
            try realm.write {
                item.done = !item.done
                

                
                //print(item.date)
            }}
        catch {
            print("error with checking the items \(error)")
        }
    }
    
    tableView.reloadData()
    
    
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
 
    override func updateModel(at indexPath: IndexPath)  {

            
        
        //print("\(itemsFor)")
        if let itemsFor = todoItems?[indexPath.row]

        {
            do {
                print("\(itemsFor)")
                
                try self.realm.write {
                    self.realm.delete(itemsFor)
                  
                } }
                
            catch {
                print("error with deleting category \(error)")
            }
        }
    }
    
    override func deleteAllItems(at indexpath : IndexPath){
        //updateModel(at: indexpath)
        
        let items = selecetedCategory!.items
        
        do {
            print("\(items)")
            
            try self.realm.write {
                self.realm.delete(items)
                
            } }
            
        catch {
            print("error with deleting category \(error)")
        }
    }
        
    }

    

//MARK: Search-Bar Methods

extension TodoListViewController : UISearchBarDelegate {


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@" ,searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {

            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}




