//
//  MatchTableViewCell.swift
//  Tinder_Clone
//
//  Created by Irfaane Ousseny on 06/01/2019.
//  Copyright © 2019 Irfaane. All rights reserved.
//

import UIKit
import Parse

class MatchTableViewCell: UITableViewCell {

    var reciepientObjectId = ""
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var messageTextLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let message = PFObject(className: "Message")
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = reciepientObjectId
        message["content"] = messageTextLabel.text
    }

}
