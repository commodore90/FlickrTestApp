//
//  FlickrTablePhotoSelectViewCell.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/28/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrTablePhotoSelectViewCell: UITableViewCell {

    
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var photoFormat: UILabel!
    @IBOutlet weak var photoDateTaken: UILabel!
    
    @IBOutlet weak var photoResolution: UILabel!
//    @IBOutlet weak var photoDateTaken2: UILabel!
//    @IBOutlet weak var photoDateTaken3: UILabel!
    
    @IBOutlet weak var photoThumbnail: UIImageView!
    
    var photoContext:FlickrPhotoContext?;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
}
