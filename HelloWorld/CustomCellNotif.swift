//
//  CustomCellNotif.swift
//  Caritathelp
//
//  Created by Jeremy gros on 25/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CustomCellNotif: UITableViewCell {
    
    @IBOutlet weak var LabelNotif: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String){
        //self.TitleNews.text = NameLabel
        //self.DateNews.text = DateLabel
//        self.ImageProfilFriends.layer.cornerRadius = self.ImageProfilFriends.frame.size.width / 2
//        self.ImageProfilFriends.layer.borderColor = UIColor.darkGrayColor().CGColor;
//        self.ImageProfilFriends.layer.masksToBounds = true
//        self.ImageProfilFriends.clipsToBounds = true
        self.LabelNotif.text = NameLabel
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}