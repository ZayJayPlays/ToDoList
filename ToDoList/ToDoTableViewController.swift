//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Zane Jones on 4/2/23.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    var toDos = [ToDo]()
    
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) -> ToDoDetailTableViewController? {
        let detailController = ToDoDetailTableViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return detailController
        }
        tableView.deselectRow(at: indexPath, animated: true)
        detailController?.toDo = toDos[indexPath.row]
        return detailController
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        cell.delegate = self
        let toDo = toDos[indexPath.row]
        cell.toDo = toDo
        cell.nameLabel.text = toDo.title
        cell.toggleButton.isSelected = toDo.isDone
        return cell
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isDone.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(toDos)
        } else if editingStyle == .insert {
            
        }
    }
    
    @IBAction func unwindToToDoList(_ segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let source = segue.source as! ToDoDetailTableViewController
        if let toDo = source.toDo {
            if let existingCellIndex = toDos.firstIndex(of: toDo) {
                toDos[existingCellIndex] = toDo
                tableView.reloadRows(at: [IndexPath(row: existingCellIndex, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                
                toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            ToDo.saveToDos(toDos)
        }
    }
}
