//
//  MyTableViewCell.swift
//  PoseFinder
//
//  Created by Vũ Phan on 20/08/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

//    @IBOutlet var myLab: UILabel!
//    @IBOutlet var myView: UIView!
//    @IBOutlet var myImg: UIImageView!
    
    
    
    
    
    @IBOutlet var myLab: UILabel!
    @IBOutlet var myBGview: UIView!
    
    @IBOutlet var myView: UIView!
    @IBOutlet var myImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.isSelected {
            self.contentView.backgroundColor = .systemYellow
            //myView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        else{
            
            self.contentView.backgroundColor = .systemYellow
            //myView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        // Configure the view for the selected state
    }
   

}
