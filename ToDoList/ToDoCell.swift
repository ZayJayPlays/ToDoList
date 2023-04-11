//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Zane Jones on 4/7/23.
//

import UIKit

protocol ToDoCellDelegate: AnyObject {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var toggleButton: UIButton!
    
    var toDo: ToDo?
    weak var delegate: (ToDoCellDelegate)?
    
    @IBAction func toggleButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    
}
