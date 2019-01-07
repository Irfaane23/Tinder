//
//  MatchVC.swift
//  Tinder_Clone
//
//  Created by Irfaane Ousseny on 06/01/2019.
//  Copyright © 2019 Irfaane. All rights reserved.
//

import UIKit
import Parse

class MatchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var pictures : [UIImage] = []
    var userID : [String] = []
    var messages : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            if let accepted = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectID", containedIn: accepted)
                query.findObjectsInBackground { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let currentUser = user as? PFUser {
                                if let pictureFile = currentUser["photo"] as? PFFileObject {
                                    pictureFile.getDataInBackground(block: { (data, eror) in
                                        if let pictureData = data {
                                            
                                            if let image = UIImage(data: pictureData) {
                                                if let objectID = currentUser.objectId {
                                                    let messagesQuery = PFQuery(className: "Messages")
                                                    messagesQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                    messagesQuery.whereKey("sender", equalTo: currentUser.objectId as Any)
                                                    messagesQuery.findObjectsInBackground(block: { (objs, error) in
                                                        var message = "No message received"
                                                        if let object = objs {
                                                            for messageInArray in object {
                                                                if let messageContent = messageInArray["content"] as? String {
                                                                    message = messageContent
                                                                }
                                                            }
                                                        }
                                                        self.messages.append(message)
                                                        self.userID.append(objectID)
                                                        self.pictures.append(image)
                                                        self.tableView.reloadData()
                                                    })
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // TableView's delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchTableViewCell {
            cell.messageTextLabel.text = "No message received"
            cell.profileIV.image = pictures[indexPath.row]
            cell.reciepientObjectId = userID[indexPath.row]
            cell.messageTextLabel.text = messages[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
   
    @IBAction func goingBackToMatches(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
