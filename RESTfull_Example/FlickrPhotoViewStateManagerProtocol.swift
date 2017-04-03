//
//  FlickrPhotoViewStateManagerProtocol.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/21/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation


protocol FlickrPhotoViewStateManagerProtocol: class {
    /* 
        Declare required interface variables
     */
    weak var photoViewDelegate:FlickrPhotoViewControllerProtocol? {get set}                            // this is going to be photoViewInstance
    
    
    
    /*
        Declare required interface methodes
    */
    func testIfUserIsLoggedIn();
    
    func fetchPhoto(photoContext: flickrPhotoContext, completionHandler: @escaping (AsyncResult<Bool>) -> ());
    // func fetchCustomPhoto();

}
