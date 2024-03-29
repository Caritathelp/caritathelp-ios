//
//  CustomCellCollectionCreateAsso.swift
//  Caritathelp
//
//  Created by Jeremy gros on 30/03/2016.
//  Copyright © 2016 Jeremy gros. All rights reserved.
//

import Foundation
import UIKit

class CustomCellCollectionCreateAsso : UICollectionViewCell {
   
    @IBOutlet weak var imageAsso: UIImageView!
    @IBOutlet weak var nomAsso: UILabel!
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    
    func setData(image: String, name: String){
        self.imageAsso.downloadedFrom(link: image, contentMode: .scaleToFill)
        self.imageAsso.layer.cornerRadius = self.imageAsso.frame.size.width / 2
        self.imageAsso.layer.borderColor = UIColor.darkGray.cgColor;
        self.imageAsso.layer.borderWidth = 1.0
        self.imageAsso.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.imageAsso.layer.shadowOpacity = 0.4
        self.imageAsso.layer.shadowColor = UIColor.black.cgColor
        self.imageAsso.layer.masksToBounds = false
        self.imageAsso.layer.masksToBounds = true
        self.imageAsso.clipsToBounds = true
        self.nomAsso.text = name

    }
    
}
