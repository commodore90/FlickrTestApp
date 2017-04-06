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
    var photoCache:NSCache<AnyObject, AnyObject> = NSCache();
    
    //MARK: Flickr Photo API instance
    let flickrPhotoAPI: FlickrPhotoAPI = FlickrPhotoAPI.init();
    
    //MARK: Initializers
    init () {
        
    }
    
    init (tablePhotoKind:String) {
        self.tablePhotoKind = tablePhotoKind;
    }
    
    //MARK: Methodes
    
    func getAllThumbnailPhotos(completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
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
    }
    
     // Get Thumbnails for searched photo
    func getThumbnailPhoto(photoRowIndx:Int, completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
        self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoURL: self.photoContextArray![photoRowIndx].thumbURL!) { (flickrAPIResponse) in
            switch flickrAPIResponse {
                case .Success(let thumbPhoto):
                    
                    self.photoContextArray![photoRowIndx].thumbPhoto = UIImage(data: thumbPhoto);
                    
                    // fire completionHandler cloasure callback
                    print("Photo ad index: \(photoRowIndx) Downloaded!");
                    completionHandler(AsyncResult.Success(true));
                    break;
                
                case .Failure(let photoThumbnailsError):
                    print("Error while getting Photo Thumbnails: \(photoThumbnailsError)");
                    // fire completionHandler cloasure callback
                    completionHandler(AsyncResult.Failure(photoThumbnailsError));
                    break;
            }
        }
    }
    
    // get all photo contexts for Photo kind
    func getPhotosContextArrayForKind(completionHandler: @escaping (AsyncResult<Bool>) -> ()) {
        
        // Search for Photos using tag:
        flickrPhotoAPI.flickrPhotosSearchByTag(photoTag: self.tablePhotoKind!) { (flickrPhotosSearchByTagRsp) in
            switch flickrPhotosSearchByTagRsp {
                case .Success(let photoContextArrayRsp):
                    
                    self.photoContextArray = photoContextArrayRsp;
                    completionHandler(AsyncResult.Success(true));
                    break;
                    
                case .Failure(let photoSearchError):
                    
                    print("Photo Search Error: \(photoSearchError)");
                    completionHandler(AsyncResult.Failure(photoSearchError));
                    self.photoContextArray = [];
                    break;
            }
        }
    }
    
    // populate table view using table view delegate methodes
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIndentifier:String = "FlickrTablePhotoSelectViewCell";
        var flickrCellData:flickrPhotoContext?;
        
        // set reusable cell indentifier and downcast to custom cell class
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? FlickrTablePhotoSelectViewCell else {
            fatalError("The dequeued cell is not an instance of FlickrTablePhotoSelectViewCell.");
        }
        
        // identify cell by row
        cell.tag = indexPath.row;

        // check if data is nil, and if yes, download Thumbnail image
        if (self.photoCache.object(forKey: (indexPath as IndexPath).row as AnyObject) != nil){
            print("Cached image at index:\(indexPath.row) used, no Download request fired")
            // cell.photoThumbnail?.image = self.photoCache.object(forKey: (indexPath as IndexPath).row as AnyObject) as? UIImage;
            let cachedPhotoContext:flickrPhotoContext = (self.photoCache.object(forKey: (indexPath as IndexPath).row as AnyObject) as? flickrPhotoContext)!; // as? UIImage;
            
            cell.photoThumbnail?.image = cachedPhotoContext.thumbPhoto;
            
            setCellLabels(cellToSet: cell, photoContext: cachedPhotoContext);
            
            cell.photoContext = cachedPhotoContext;
        }
        
        else {
            flickrCellData = self.photoContextArray?[indexPath.row];
            
            setCellLabels(cellToSet: cell, photoContext: flickrCellData!);

            // download Thumbnail for indexPath:
            DispatchQueue.global().async {
                
                self.getThumbnailPhoto(photoRowIndx: indexPath.row) { (flickrThumbnailPhotoDownloadRsp) in
                    
                    switch (flickrThumbnailPhotoDownloadRsp) {
                    case .Success(_):
                        DispatchQueue.main.async {
                            // Before assign the image, check whether the current cell is visible
                            if let updateCell:FlickrTablePhotoSelectViewCell = tableView.cellForRow(at: indexPath) as! FlickrTablePhotoSelectViewCell? {
                                let cellImage:UIImage! = flickrCellData?.thumbPhoto;
                                
                                if (cell.tag == indexPath.row) {
                                    updateCell.photoThumbnail.image = nil;
                                    updateCell.photoThumbnail.image = cellImage;
                                    updateCell.photoContext = flickrCellData!;
                                    updateCell.setNeedsLayout();
                                    // cache image for reuse without download
                                    self.photoCache.setObject(flickrCellData!, forKey: (indexPath as IndexPath).row as AnyObject)
                                    
                                }
                            }
                        }

                        print("Thumbnail photo downloaded!");
                        break;
                        
                    case .Failure(let thumbnailDownloadError):
                        print("Thumbnail photo Download Error: \(thumbnailDownloadError)");
                        break;
                    }
                }
            }
        }
        return cell;
     
    }

    /*
     Internal Methodes
     */
    func setCellLabels(cellToSet: FlickrTablePhotoSelectViewCell, photoContext: flickrPhotoContext) {
        cellToSet.photoTitle.text = photoContext.photoInfo?.title;
        cellToSet.photoFormat.text = photoContext.photoInfo?.originalFormat;
        cellToSet.photoDateTaken.text = photoContext.photoInfo?.dateTaken;
        cellToSet.photoResolution.text = ""; // photoContext.
    }
}
