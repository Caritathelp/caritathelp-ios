//
//  CustomCellInviteMember.swift
//  Caritathelp
//
//  Created by Jeremy gros on 26/05/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellInviteMember: UITableViewCell {
    
    @IBOutlet weak var ImageProfilFriends: UIImageView!
    @IBOutlet weak var NameFriends: UILabel!
    //@IBOutlet weak var DetailFriends: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(NameLabel: String, imageName: String){
        self.ImageProfilFriends.downloadedFrom(link: imageName, contentMode: .scaleAspectFit)
        self.ImageProfilFriends.layer.cornerRadius = self.ImageProfilFriends.frame.size.width / 2
        self.ImageProfilFriends.layer.borderColor = UIColor.darkGray.cgColor;
        self.ImageProfilFriends.layer.masksToBounds = true
        self.ImageProfilFriends.clipsToBounds = true
        self.NameFriends.text = NameLabel
        
        //cell.imageView?.layer.cornerRadius = 25
        //cell.imageView?.clipsToBounds = true
    }
}
