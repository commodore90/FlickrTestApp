//
//  TablePhotoBaseStateManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/30/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation
import UIKit

// this class shouold populate table view with apropriate content
class TablePhotoBaseStateManager : FlickrTablePhotoSelectViewStateManagerProtocol {
    
    //MARK: Delegates
    // use this delegate to access table view delegate methodes to present data
    var tablePhotoSelectViewDelegate : FlickrTablePhotoSelectViewProtocol?;
    
    //MARK: Local variables
    var tablePhotoKind:String?; // used as search criterium
    var photoContextArray:[flickrPhotoContext]?;
    
    //MARK: Flickr Photo API instance
    let flickrPhotoAPI: FlickrPhotoAPI = FlickrPhotoAPI.init();
    
    //MARK: Initializers
    init () {
        
    }
    
    init (tablePhotoKind:String) {
        self.tablePhotoKind = tablePhotoKind;
    }
    
    //MARK: Methodes
    // get all photo contexts for Photo kind
    func getPhotosContextArrayForKind(completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
        
        // Search for Photos using tag:
        flickrPhotoAPI.flickrPhotosSearchByTag(photoTag: self.tablePhotoKind!) { (flickrPhotosSearchByTagRsp) in
            switch flickrPhotosSearchByTagRsp {
            case .Success(let photoContextArrayRsp):
                self.photoContextArray = photoContextArrayRsp;
                
                // Get Thumbnails for searched photos
                for i in 0..<(self.photoContextArray)!.count {
                    self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoURL: self.photoContextArray![i].thumbURL!) { (flickrAPIResponse) in
                        
                        switch flickrAPIResponse {
                        case .Success(let thumbPhoto):
                            self.photoContextArray![i].thumbPhoto = UIImage(data: thumbPhoto);
                            
                            // fire completionHandler cloasure callback
                            if (i == (self.photoContextArray?.count)!-1) {
                                completionHandler(AsyncResult.Success(true));
                            }
                            break;
                        case .Failure(let photoThumbnailsError):
                            print("Error while getting Photo Thumbnails: \(photoThumbnailsError)");
                            
                            // fire completionHandler cloasure callback
                            completionHandler(AsyncResult.Failure(photoThumbnailsError));
                            break;
                        }
                    }
                }
                
                
                
                
//                // present Photos and info data in cell using TablePhotoView Delegate
//                self.tablePhotoSelectViewDelegate?.flickrRefreshPhotoTable();
                
                
                break;
            case .Failure(let photoSearchError):
                print("Photo Search Error: \(photoSearchError)");
                self.photoContextArray = [];
                break;
            }
        }
    }
    
//    func getThumbnailPhotos(completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
//        // Get Thumbnails for searched photos
//        for i in 0..<(self.photoContextArray)!.count {
//            self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoURL: self.photoContextArray![i].thumbURL!) { (flickrAPIResponse) in
//                
//                switch flickrAPIResponse {
//                case .Success(let thumbPhoto):
//                    self.photoContextArray![i].thumbPhoto = UIImage(data: thumbPhoto);
//                    
//                    // fire completionHandler cloasure callback
//                    if (i == (self.photoContextArray?.count)!-1) {
//                        completionHandler(AsyncResult.Success(true));
//                    }
//                    break;
//                case .Failure(let photoThumbnailsError):
//                    print("Error while getting Photo Thumbnails: \(photoThumbnailsError)");
//                    
//                    // fire completionHandler cloasure callback
//                    completionHandler(AsyncResult.Failure(photoThumbnailsError));
//                    break;
//                }
//            }
//        }
//    }
    
    // get thumbnail photos
    func getPhotosThumbnailArray() {
        
    }
    
    // get photos info
    func getPhotosInfo() {
        
    }
    
    // populate table view using table view delegate methodes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIndentifier:String = "FlickrTablePhotoSelectViewCell";
        var flickrCellData:flickrPhotoContext?;
        
        // set reusable cell indentifier and downcast to custom cell class
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? FlickrTablePhotoSelectViewCell else {
            fatalError("The dequeued cell is not an instance of FlickrTablePhotoSelectViewCell.");
        }
        
        // iterate over data and map data to cell 
        // check if data is nil, and if yes, download Thumbnail image
        if self.photoContextArray?[indexPath.row].thumbPhoto == nil {
            // download Thumbnail for indexPath:
        }
        
        flickrCellData = self.photoContextArray?[indexPath.row];
        
        cell.photoTitle.text      = flickrCellData?.photoInfo?.title;
        cell.photoFormat.text     = flickrCellData?.photoInfo?.originalFormat;
        cell.photoDateTaken.text  = flickrCellData?.photoInfo?.dateTaken;
        cell.photoResolution.text = " "; // flickrCellData?.photoInfo?.resolution;
        
        // download asynchronusly
        
        cell.photoThumbnail.image = flickrCellData?.thumbPhoto;
        cell.photoContext = flickrCellData!;
        
        
        return cell;
    }
    
    
    
}
