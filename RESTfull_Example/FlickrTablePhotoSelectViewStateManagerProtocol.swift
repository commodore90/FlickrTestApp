//
//  FlickrTablePhotoSelectViewStateManagerProtocol.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/30/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

protocol FlickrTablePhotoSelectViewStateManagerProtocol:class {
    /*
     Declare required interface variables
     */
    var tablePhotoSelectViewDelegate:FlickrTablePhotoSelectViewProtocol? {get set};
    var photoContextArray:[FlickrPhotoContext]? {get set};
    
    /*
     Declare required interface methodes
    */
    
    func getPhotosContextArrayForKind(completionHandler: @escaping (AsyncResult<Bool>) -> ());
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell;
}
