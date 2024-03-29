//
//  CustomCellInvitations.swift
//  Caritathelp
//
//  Created by Jeremy gros on 29/06/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class CustomCellInvits: UITableViewCell {
    
    @IBOutlet weak var LabelNotif: UILabel!
    @IBOutlet weak var DetailNotif: UILabel!
    @IBOutlet weak var ImageProfilFriends: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(NameLabel: String, DetailLabel: String, imageName: String){
        self.ImageProfilFriends.downloadedFrom(link: imageName, contentMode: .scaleToFill)
        self.ImageProfilFriends.layer.cornerRadius = self.ImageProfilFriends.frame.size.width / 2
        self.ImageProfilFriends.layer.borderColor = UIColor.lightGray.cgColor;
        self.ImageProfilFriends.layer.borderWidth = 1.0
        self.ImageProfilFriends.layer.masksToBounds = true
        self.ImageProfilFriends.clipsToBounds = true
        self.LabelNotif.text = NameLabel
        self.DetailNotif.text = DetailLabel
    }
}
