//
//  AddEventVC.swift
//  Events
//
//  Created by A Boon-Eye on 1/26/18.
//  Copyright © 2018 Jeffrey Baucom. All rights reserved.
//

import UIKit

class AddEventVC: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var infoField: UITextField!
    @IBOutlet weak var eventLabel: UILabel!
    
    var isEdit: Bool = false
    var indexPath: IndexPath?
    var item: Event?
    var delegate: EventTableDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if isEdit {
            print(item)
            titleField?.text = item?.title
            infoField?.text = item?.info
            datePicker.date = (item?.time)!
            eventLabel.text = item?.title
        }
       self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
    }
    
    func doneButtonAction() {
        self.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        infoField.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func savePressed(_ sender: UIButton) {
        print("here")
        if isEdit {
            delegate?.savePressedEdit(by: self)
        } else {
            delegate?.savePressed(by: self)
        }

        dismiss(animated: true, completion: nil)
    }
    
}
