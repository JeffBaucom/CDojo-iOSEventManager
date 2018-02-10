//
//  EventVC.swift
//  Events
//
//  Created by A Boon-Eye on 1/26/18.
//  Copyright © 2018 Jeffrey Baucom. All rights reserved.
//

import UIKit
import CoreData

class EventVC: UITableViewController, EventTableDelegate {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let sections = ["Incomplete", "Complete"]
    var items: [[Event]] = [[], []]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        sortTable()
        tableView.reloadData()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        cell.titleLabel?.text = dateFormatter.string(from: items[indexPath.section][indexPath.row].time!) + " " + items[indexPath.section][indexPath.row].title!
        cell.indexPath = indexPath
        cell.delegate = self
        
        if indexPath.section == 1 {
            cell.editButton.isHidden = true
        } else {
            cell.editButton.isHidden = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section].remove(at: indexPath.row)
        if indexPath.section == 0 {
            //incomplete -> complete
            item.complete = true
            items[1].append(item)

        } else {
            item.complete = false
            items[0].append(item)
            //complete -> incomplete
            
        }
        sortTable()
        tableView.reloadData()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.section].remove(at: indexPath.row)
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        
        tableView.reloadData()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let controller = segue.destination as! AddEventVC
        controller.delegate = self
        if let indexPath = sender as? IndexPath {
            controller.item = items[indexPath.section][indexPath.row]
            controller.indexPath = indexPath
            controller.isEdit = true
        } else {
            controller.isEdit = false
        }
    }
    
    func goToEdit(path: IndexPath) {
        performSegue(withIdentifier: "GoToAdd", sender: path)
    }
    

    func savePressed(by controller: AddEventVC) {
        print("new Item needs to be loaded")
        let item = Event(context: managedObjectContext)
        item.title = controller.titleField?.text
        item.info = controller.infoField?.text!
        item.complete = false
        item.time = controller.datePicker.date
        items[0].append(item)
        sortTable()
        tableView.reloadData()
    }
    
    func savePressedEdit(by controller: AddEventVC) {
        if let ip = controller.indexPath {
            let item = items[ip.section][ip.row]
            item.title = controller.titleField?.text
            item.info = controller.infoField?.text!
            item.complete = false
            item.time = controller.datePicker.date
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        sortTable()
        tableView.reloadData()
    }
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
    }
    
    func sortTable() {
        var unfinished = items[0].sorted(by: {$0.time!.compare($1.time!) == .orderedAscending})
        var finished = items[1].sorted(by: {$0.time!.compare($1.time!) == .orderedAscending})
        items[0] = unfinished
        items[1] = finished
    }

    func fetchAllItems() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
        do {
            let result = try managedObjectContext.fetch(request)
            let iters = result as! [Event]
            for i in iters {
                if i.complete {
                    items[1].append(i)
                } else {
                    items[0].append(i)
                }
            }
        } catch {
            print("\(error)")
        }
        
    }


}

class EventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    var indexPath: IndexPath?
    var delegate: EventTableDelegate?
    
    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.goToEdit(path: indexPath!)
    }
    
}
