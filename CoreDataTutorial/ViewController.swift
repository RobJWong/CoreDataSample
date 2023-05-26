//
//  ViewController.swift
//  CoreDataTutorial
//
//  Created by Robert Wong on 5/24/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //viewContext is where you go to perform object functions in the core data database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoListItem]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //getAllItems()
        filterItems()
        title = "CoreData To Do List"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var context = cell.defaultContentConfiguration()
        guard let name = model.name, let createdAt = model.createdAt else { return cell }
        context.text = "\(name) - \(createdAt)"
        cell.contentConfiguration = context
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your  item", preferredStyle: .alert)
            alert.addTextField()
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName )
            }))
            self.present(alert, animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        present(sheet, animated: true)
    }
 
    func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            //Anything UI related should be done on the main thread
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func filterItems() {
        do {
            models = try ToDoListItem.filterRequest(context: context, queryString: "tuo")!
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            //error
        }
    }
    
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createdAt = Date()
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }

}

