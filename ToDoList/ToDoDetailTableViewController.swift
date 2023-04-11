//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Zane Jones on 4/5/23.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {
    @IBOutlet var toggleButton: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var saveButton: UIButton!
    
    var toDo: ToDo?
    
    var datePickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDo = toDo {
            navigationItem.title = "To-Do"
            nameTextField.text = toDo.title
            toggleButton.isSelected = toDo.isDone
            datePicker.date = toDo.dueDate
            notesTextField.text = toDo.notes
            
        } else {
            datePicker.date = Date().addingTimeInterval(24*60*60)
        }
        updateSaveButtonState()
        updateDueDateLabel(date: datePicker.date)
    }
    
    func updateDueDateLabel(date: Date) {
        dateLabel.text = date.formatted(.dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
    }
    
    func updateSaveButtonState() {
        let shouldEnableSaveButton = nameTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    @IBAction func titleTextChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    @IBAction func returnKeyTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: Any) {
        toggleButton.isSelected.toggle()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            datePickerHidden.toggle()
            updateDueDateLabel(date: datePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where datePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let name = nameTextField.text
        let isComplete = toggleButton.isSelected
        let dueDate = datePicker.date
        let notes = notesTextField.text
        
        if toDo != nil {
            toDo?.title = name!
                toDo?.isDone = isComplete
                toDo?.dueDate = dueDate
            toDo?.notes = notes!
            } else {
                toDo = ToDo(title: name!, isDone: isComplete,
                            dueDate: dueDate, notes: notes!)
            }
    }
}
