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
    var tablePhotoKind:String?;                                 // used as search criterium
    var photoContextArray:[FlickrPhotoContext]?;
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
    
    func getAllThumbnailPhotos(completionHandler: @escaping (AsyncResult<FlickrAPIResponse>) -> ()) { // Bool
        // Get Thumbnails for searched photos
        for i in 0..<(self.photoContextArray)!.count {
            self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoURL: self.photoContextArray![i].thumbURL!) { (flickrAPIResponse) in
                
                switch flickrAPIResponse {
                case .Success(let flickrAPIResponse):  // let thumbPhoto
                    self.photoContextArray![i].thumbPhoto = UIImage(data: (flickrAPIResponse as FlickrAPIResponse).responseData!);  // thumbPhoto
                    
                    // fire completionHandler cloasure callback
                    if (i == (self.photoContextArray?.count)!-1) {
                        completionHandler(AsyncResult.Success(flickrAPIResponse));  // true
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
    func getThumbnailPhoto(photoRowIndx:Int, completionHandler: @escaping (AsyncResult<FlickrAPIResponse>) -> ()) { // Bool
        self.flickrPhotoAPI.flickrDownloadPhotoFromURL(photoURL: self.photoContextArray![photoRowIndx].thumbURL!) { (flickrAPIResponse) in
            switch flickrAPIResponse {
                case .Success(let flickrAPIResponse): // let thumbPhoto
                    
                    self.photoContextArray![photoRowIndx].thumbPhoto = UIImage(data: (flickrAPIResponse as FlickrAPIResponse).responseData!);  // thumbPhoto

                    print("Photo ad index: \(photoRowIndx) Downloaded!");
                    completionHandler(AsyncResult.Success(flickrAPIResponse)); // true
                    break;
                
                case .Failure(let photoThumbnailsError):
                    print("Error while getting Photo Thumbnails: \(photoThumbnailsError)");
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
        var flickrCellData:FlickrPhotoContext?;
        
        // set reusable cell indentifier and downcast to custom cell class
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? FlickrTablePhotoSelectViewCell else {
            fatalError("The dequeued cell is not an instance of FlickrTablePhotoSelectViewCell.");
        }
        
        // Identify cell by row and set cell data
        cell.tag = indexPath.row;
        flickrCellData = self.photoContextArray?[indexPath.row];
        
        if (self.photoCache.object(forKey: flickrCellData?.thumbURL?.path as AnyObject) != nil) {  // (indexPath as IndexPath).row
            
            print("Cached image at index:\(indexPath.row) used, no Download request fired")
            let cachedPhotoContext:FlickrPhotoContext = (self.photoCache.object(forKey: flickrCellData?.thumbURL?.path as AnyObject) as? FlickrPhotoContext)!; // (indexPath as IndexPath).row
            
            cell.photoThumbnail?.image = cachedPhotoContext.thumbPhoto;
            setCellLabels(cellToSet: cell, photoContext: cachedPhotoContext);
            cell.photoContext = cachedPhotoContext;
        }
            
        else {
            
            setCellLabels(cellToSet: cell, photoContext: flickrCellData!);

            /* 
             Namerno sam ostavio ovaj komentar:
             Pitanje je: Da li , ako API manager radi na fetch-u podataka sa web-a, kao sto moj API radi, 
                        treba da sam completionHadler API metode koja poziva dataTask bude pozvan u okviru DispatchQueue.main.async {} ?
             
                        Takodje ovaj DispatchQueue.global().async {} blok nije potreban ovde jer je completionHandler metode getThumbnailPhoto
                        vec obuhvacen i vracen u main thread

 
            */
            
            // download Thumbnail for indexPath:
            // DispatchQueue.global().async {
                
                self.getThumbnailPhoto(photoRowIndx: indexPath.row) { (flickrThumbnailPhotoDownloadRsp) in
                    
                    switch (flickrThumbnailPhotoDownloadRsp) {
                    case .Success(let flickrAPIResponse):
                        DispatchQueue.main.async {
                            // Before assign the image, check whether the current cell is visible
                            if let updateCell:FlickrTablePhotoSelectViewCell = tableView.cellForRow(at: indexPath) as! FlickrTablePhotoSelectViewCell? {
                                let cellImage:UIImage! = flickrCellData?.thumbPhoto;
                                
                                if (cell.tag == indexPath.row) {
                                    updateCell.photoThumbnail.image = nil;
                                    updateCell.photoThumbnail.image = cellImage;
                                    updateCell.photoContext = flickrCellData!;
                                    // updateCell.setNeedsLayout();
                                    // cache image for reuse without download
                                    self.photoCache.setObject(flickrCellData!, forKey: ((flickrAPIResponse as FlickrAPIResponse).responseRequestURL?.path)! as AnyObject)  // (indexPath as IndexPath).row
                                    
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
             //}
        }
        return cell;
        
    }

    /*
     Internal Methodes
     */
    func setCellLabels(cellToSet: FlickrTablePhotoSelectViewCell, photoContext: FlickrPhotoContext) {
        cellToSet.photoTitle.text = photoContext.photoInfo?.title;
        cellToSet.photoFormat.text = photoContext.photoInfo?.originalFormat;
        cellToSet.photoDateTaken.text = photoContext.photoInfo?.dateTaken;
        cellToSet.photoResolution.text = ""; // photoContext.
    }
}
