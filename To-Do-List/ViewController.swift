//
//  ViewController.swift
//  To-Do-List
//
//  Created by Omar Pakr on 10/12/2023.
//

import UIKit

class ViewController: UIViewController {
    var items = [TodoItem]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTools()
        getData()
    }
    private func initTools(){
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: NSLocalizedString("Add New item", comment: ""), message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (cancel) in
        }
        let save = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default) { (save) in
            if let newItemTitle = textField.text, !newItemTitle.isEmpty {
                let newItem = TodoItem(title: newItemTitle, isCompleted: true)
                self.items.append(newItem)
                self.saveItemsToUserDefaults(toDoItem: self.items, forKey: "todoItems")
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (text) in
            textField = text
            textField.placeholder = NSLocalizedString("Add New item", comment: "")
        }
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
    }
    private func saveItemsToUserDefaults(toDoItem:[TodoItem], forKey : String, indexPath : Int = 0) {
    
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(toDoItem)
            UserDefaults.standard.set(encodedData, forKey: forKey)
        } catch {
            print("Error encoding items")
        }
    }
    
    private func getData() {
        if let savedItemsData = UserDefaults.standard.data(forKey: "todoItems")  {
            do {
                let decodedItems = try JSONDecoder().decode([TodoItem].self, from: savedItemsData)
              
                self.items.append(contentsOf: decodedItems)
                
            } catch {
                print("Error decoding saved items")
            }
        }
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.isEmpty {
            emptyView.isHidden = false
            tableView.isHidden = true
            return 0
        }else {
            emptyView.isHidden = true
            tableView.isHidden = false
            return items.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoListCell", for: indexPath) as! CustomTableViewCell
        cell.toDoLabel.text = items[indexPath.row].title
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {  _,_,completion in
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveItemsToUserDefaults(toDoItem: self.items, forKey: "forKey")
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            
            let textField = UITextField()
            let alert = UIAlertController(title: NSLocalizedString("Edit item", comment: ""), message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (cancel) in
            }
            let save = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default) { _ in
                if let newText = textField.text, !newText.isEmpty {
                   
                    self.items[indexPath.row].title = newText
                    self.saveItemsToUserDefaults(toDoItem: self.items, forKey: "forKey", indexPath: indexPath.row)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    print("New Text: \(newText)")
                }
            }
            alert.addTextField { (text) in
                text.text = self.items[indexPath.row].title
            }
            alert.addAction(cancel)
            alert.addAction(save)
            self.present(alert, animated: true, completion: nil)
            completion(true)
        }
        
        editAction.image = UIImage(systemName: "pencil")
        editAction.backgroundColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        
        
        let congig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return congig
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sendActin = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            print("Send a message to \(self.items[indexPath.row])")
            
            completion(true)
        }
        sendActin.image = UIImage(systemName: "envelope")
        sendActin.backgroundColor = .systemMint
        let congig = UISwipeActionsConfiguration(actions: [sendActin])
        return congig
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//extension String {
//    func localized() -> String {
//        return NSLocalizedString(self,
//                                 tableName: "Localizable",
//                                 bundle: .main,
//                                 value: self,
//                                 comment: self
//        )
//    }
//}
