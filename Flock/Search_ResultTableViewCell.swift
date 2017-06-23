//
//  Search_ResultTableViewCell.swift
//  Flock
//
//  Created by Rishabh Yadav on 6/22/17.
//  Copyright © 2017 Flock. All rights reserved.
//

import UIKit

class Search_ResultTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
