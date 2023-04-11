//
//  ToDo.swift
//  ToDoList
//
//  Created by Zane Jones on 4/1/23.
//

import Foundation

struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    var dueDate: Date
    var notes: String
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    static let archiveURL = documentsDirectory!.appendingPathComponent("toDos").appendingPathExtension("plist")
    
    init(title: String, isDone: Bool, dueDate: Date, notes: String) {
        self.id = UUID()
        self.title = title
        self.isDone = isDone
        self.dueDate = dueDate
        self.notes = notes
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func saveToDos(_ toDos: [ToDo]?) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadToDos() -> [ToDo]? {
        guard let codedToDos = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    static func loadSampleToDos() -> [ToDo] {
        let toDo1 = ToDo(title: "Do something", isDone: false, dueDate: Date(), notes: "Anything")
        let toDo2 = ToDo(title: "Do something else", isDone: false, dueDate: Date(), notes: "Seriously, anything.")
        return [toDo1, toDo2]
    }
}
