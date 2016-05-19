//
//  TableViewCell.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import UIKit

class PerfTableViewCell: UITableViewCell {
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()
        textLabel?.font = UIFont(name: "RopaSans", size: 15)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
