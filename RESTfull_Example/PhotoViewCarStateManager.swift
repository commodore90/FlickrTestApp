//
//  PhotoViewCarStateManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/22/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewCarStateManager : FlickrPhotoViewBaseStateManager {
    
    /*
     Dependecy Injection
     */
    override init () {
        super.init(photoTag: "Car");
    }
}
