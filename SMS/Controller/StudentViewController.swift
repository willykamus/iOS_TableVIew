//
//  StudentViewController.swift
//  SMS
//
//  Created by William Ching on 2019-04-03.
//  Copyright © 2019 William Ching. All rights reserved.
//

import UIKit

class StudentViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveStudent(_ sender: UIButton) {
        
        storeStudent { (done) in
            if done {
                // Return to the previous page
                // It will take you back to the previuos page
                navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil) //this does not close the view
            } else {
                // Try to save again using new data
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}


extension StudentViewController {
    
    // Completion: is added manually
    func storeStudent(completion: (_ done:Bool) ->() ) {
        
        // We need persistent data object
        // Dao = data object
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        let student = Student(context: managedContext)
        student.firstName = firstNameTextField.text
        student.lastName = lastNameTextField.text
        
        do {
            try managedContext.save()
            print("Student Save")
            completion(true)
        } catch {
            print("Failed: ", error.localizedDescription)
        }
    }
    
}
