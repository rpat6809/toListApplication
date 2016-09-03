//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Ronak Patel on 3/09/2016.
//  Copyright © 2016 University Of Sydney. All rights reserved.
//

import UIKit
import RealmSwift
class TaskListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var lists : Results<TaskList>!
    let realmObj = try! Realm()
    var isEditingMode = false
    
    var currentCreateAction:UIAlertAction!
    @IBOutlet weak var taskListTableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        readTasksAndUpdateUI()
    }
    
    func readTasksAndUpdateUI(){
        
        lists = realmObj.objects(TaskList)
        self.taskListTableView.setEditing(false, animated: true)
        self.taskListTableView.reloadData()
    }
    
    // MARK: - User Actions -
    
    
    @IBAction func didSelectSortCriteria(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0{
            
            // A-Z
            self.lists = self.lists.sorted("name")
        }
        else{
            // date
            self.lists = self.lists.sorted("createdAt", ascending:false)
        }
        self.taskListTableView.reloadData()
    }
    
    @IBAction func didClickOnEditButton(sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode
        self.taskListTableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func didClickOnAddButton(sender: UIBarButtonItem) {
        
        displayAlertToAddTaskList(nil)
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func listNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.enabled = textField.text?.characters.count > 0
    }
    
    func displayAlertToAddTaskList(updatedList:TaskList!){
        
        var title = "ADD New TasK"
        var doneTitle = "Save"
        if updatedList != nil{
            title = "Update Task"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Can You Please Write the name of Task.", preferredStyle: UIAlertControllerStyle.Alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.Default) { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if updatedList != nil{
                // update mode
                try! self.realmObj.write{
                    updatedList.name = listName!
                    self.readTasksAndUpdateUI()
                }
            }
            else{
                
                let newTaskList = TaskList()
                newTaskList.name = listName!
                
                try! self.realmObj.write{
                    
                    self.realmObj.add(newTaskList)
                    self.readTasksAndUpdateUI()
                }
            }
            
            print(listName)
        }
        
        alertController.addAction(createAction)
        createAction.enabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(TaskListViewController.listNameFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
            if updatedList != nil{
                textField.text = updatedList.name
            }
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource -
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let listsTasks = lists{
            return listsTasks.count
        }
        return 0
    }
    @IBOutlet weak var createdAt: UILabel!
    //let currentDateTime = NSDate()
    
    
    
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
         let cell = tableView.dequeueReusableCellWithIdentifier("listCell") as? CustomTableViewCell
        //let cell = tableView.dequeueReusableCellWithIdentifier("listCell")
        
        let list = lists[indexPath.row]
            let todaysDate:NSDate = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            //let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
           // if list.createdAt != nil {
              cell!.createdAt?.text = dateFormatter.stringFromDate(list.createdAt)
            //}
         
            cell!.taskName?.text = list.name
           cell!.countInside?.text = "\(list.tasks.count) Tasks"
        //cell?.textLabel?.text = list.name
        //cell?.detailTextLabel?.text = "\(list.tasks.count) Tasks"
           // createdAt.text = dateFormatter.stringFromDate(list.createdAt)
           
        return cell!
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (deleteAction, indexPath) -> Void in
            
            
            let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .ActionSheet)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: {
                (alert:UIAlertAction!) in
        
                let listToBeDeleted = self.lists[indexPath.row]
                try! self.realmObj.write{
                    
                    self.realmObj.delete(listToBeDeleted)
                    self.readTasksAndUpdateUI()
                }

                
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
 
        
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Edit") { (editAction, indexPath) -> Void in
            
            // Editing will go here
            let listToBeUpdated = self.lists[indexPath.row]
            self.displayAlertToAddTaskList(listToBeUpdated)
            
        }
        return [deleteAction, editAction]
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("openTasks", sender: self.lists[indexPath.row])
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let taskViewController = segue.destinationViewController as! TaskViewController
        taskViewController.selectedList = sender as! TaskList
    }


}
