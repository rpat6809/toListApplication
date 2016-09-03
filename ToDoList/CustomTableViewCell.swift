//
//  CustomTableViewCell.swift
//  ToDoList
//
//  Created by Ronak Patel on 3/09/2016.
//  Copyright © 2016 University Of Sydney. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var countInside: UILabel!
    
    @IBOutlet weak var createdAt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
