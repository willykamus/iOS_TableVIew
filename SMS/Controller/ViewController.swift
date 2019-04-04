//
//  ViewController.swift
//  SMS
//
//  Created by William Ching on 2019-04-03.
//  Copyright © 2019 William Ching. All rights reserved.
//

import UIKit
import CoreData

//Global variable
//It will be share will all value
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class ViewController: UIViewController {
    
    let cellId = "CellId"

    @IBOutlet weak var tableView: UITableView!
    
    var studentList = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        
    }
    // This will be launch every time you come back to the view within the app
    override func viewWillAppear(_ animated: Bool) {
        fetchAction()
        tableView.reloadData()
    }
    
    func fetchAction() {
        
        fetchStudents {
            (done) in
            if done {
                if studentList.count > 0 {
                    tableView.isHidden = false
                }
                //print("Data loaded! XD")
            } else {
                tableView.isHidden = true
                //print("Error")
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Return the numbers of row in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeueReusableCell is the cell prototype that we created
        // for (where the cell is going to be place... index.. but it is provided)
        // convert this from UITableViewCell to something that I can manage and manipulate
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TableViewCell
        
        let student = studentList[indexPath.row]
        cell.studentName.text = (student.firstName ?? "N/A") + " " + (student.lastName ?? "N/A")
        if student.firstName == student.lastName {
            cell.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            cell.studentName.textAlignment = .center
            cell.studentName.textColor = .white
        }
        return cell
        
    }
    // This is just saying that if it possible to edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove") {
            (action, indexPath) in
            self.removeStudent(indexPath: indexPath)
            self.fetchAction()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let updateAction = UITableViewRowAction(style: .normal, title: "Upper") {
            (action, indexPath) in
            self.updateStudent(indexPath: indexPath)
            self.fetchAction()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        removeAction.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        updateAction.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        return [updateAction, removeAction]
    }
    
}

extension ViewController {
    
    func fetchStudents(completion:(_ done: Bool )->()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        // Get the data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        // Fetch the data
        do {
            studentList = try managedContext.fetch(request) as! [Student]
            completion(true)
        } catch {
            print("Failed to fetch student: ", error.localizedDescription)
            completion(false)
        }

    }
    
    func removeStudent(indexPath: IndexPath) {
        
        guard let mananedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        mananedContext.delete(studentList[indexPath.row])
        do {
            try mananedContext.save()
        } catch {
            print("Failed to remove student: ", error.localizedDescription)
        }
    }
    func updateStudent(indexPath: IndexPath) {
        
        guard let mananedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let student = studentList[indexPath.row]
        student.lastName = student.lastName?.localizedUppercase
        
        do {
            try mananedContext.save()
        } catch {
            print("Failed to update student: ", error.localizedDescription)
        }
        
    }
    
}

