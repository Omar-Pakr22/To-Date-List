//
//  ViewController.swift
//  To-Do-List
//
//  Created by Omar Pakr on 10/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var items = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New item", message: "", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancel) in
             
        }
        
        let save = UIAlertAction(title: "Save", style: .default) { (save) in
            
            self.items.append(textField.text!)
            self.tableView.reloadData()
            
             
        }
        alert.addTextField { (text) in
            textField = text
            textField.placeholder = "Add New item"
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
              return cell
    }
}
