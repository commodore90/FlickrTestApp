//
//  FlickrImageAPI.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/17/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

// use fllickr similarity search

class FlickrPhotoAPI : FlickrRestFullBaseAPIManager{
    
    override init () {
        
    }
    
    /*
        Search User Photos by Photo tag
        

     */

    /// - photoTag("photo search criterium");
    /// - completionHandler("Array of Photo contexts -> [flickrPhotoContext]");
    
    func flickrPhotosSearchByTag(photoTag:String, completionHandler: @escaping (AsyncResult<[flickrPhotoContext]>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = FlickrHelperMethodes.fickrGeneratePhotosSearchRequest(photoTag: photoTag);
        var responseString:String?;
        var responseJson:NSDictionary = NSDictionary.init();
        var photoStatusArray:[flickrPhotoContext] = [];
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    print("Response Data [flickrPhotosSearchByTag]: " + responseString!);
                    
                    // Parse response JSON data, check for status -> stat : ok
                    responseJson = FlickrHelperMethodes.flickrGetJSONDictionary(data: flickrResponse.responseData!)!;
                    
                    // Parse JSON Dictionary, and store: id, secret, farm, server for each photo
                    if let photoNumberInResponse:String = ((responseJson["photos"] as? NSDictionary)?.value(forKey: "total")) as? String {
                        let photoNum:Int = Int(photoNumberInResponse)!;
                        for i in 0..<photoNum {
                            let photoResponse:NSDictionary = (((( ((responseJson["photos"] as? NSDictionary)?.value(forKey: "photo")) as? NSArray)?[i]) as? NSDictionary))!
                            let photoInfo:flickrPhotoInfo = flickrPhotoInfo.init(
                                originalFormat: String(describing: photoResponse["originalformat"]!),
                                title: String(describing: photoResponse["title"]!),
                                dateTaken: String(describing: photoResponse["datetaken"]!)
                            );
                            
                            let photoContext:flickrPhotoContext = flickrPhotoContext.init(
                                id:        String(describing: photoResponse["id"]!),
                                secret:    String(describing: photoResponse["secret"]!),
                                server:    String(describing: photoResponse["server"]!),
                                farm:      String(describing: photoResponse["farm"]!),
                                thumbURL:  URL.init(string: String(describing: photoResponse["url_t"]!))!,
                                photoInfo: photoInfo
                            );
                            photoStatusArray.append(photoContext);
                        }
                    }
                    else {
                        print("No images fot requested Photo Tag!");
                    }
                    
                    completionHandler(AsyncResult.Success(photoStatusArray));
                    break;
                    
                case .Failure(let flickrError):
                    print("completionHandler: \(flickrError)");
                    
                    // self.requestToken = nil;
                    
                    completionHandler(AsyncResult.Failure(flickrError));
                    break;
                }
            }
        }
    }
    
    func flickrGetPhotoInfo(photoContext: flickrPhotoContext, completionHandler: @escaping (AsyncResult<flickrPhotoInfo>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = FlickrHelperMethodes.flickrGeneratePhotoInfoRequest(photoId: photoContext.id);
        var responseString:String?;
        var responseJson:NSDictionary = NSDictionary.init();
        let photoInfo:flickrPhotoInfo = flickrPhotoInfo.init();
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    print("Response Data [flickrGetPhotoInfo]: " + responseString!);
                    
                    // Parse response JSON data, check for status
                    responseJson = FlickrHelperMethodes.flickrGetJSONDictionary(data: flickrResponse.responseData!)!
                    
                    // Parse JSON Dictionary, and store: id, secret, farm, server for each photo
                    photoInfo.originalFormat = (responseJson["photo"] as? NSDictionary)?.value(forKey: "originalformat") as? String;
                    photoInfo.title          = ((responseJson["photo"] as? NSDictionary)?.value(forKey: "title") as! NSDictionary).value(forKey: "_content") as? String;
                    photoInfo.dateTaken      = ((responseJson["photo"] as? NSDictionary)?.value(forKey: "dates") as! NSDictionary).value(forKey: "taken") as? String;
                    
                    completionHandler(AsyncResult.Success(photoInfo));
                    break;
                
                case .Failure(let flickrError):
                    
                    break;
                }
            }
        }
    }

    
//    func flickrGetThumbnailPhotos(photoContextArray: [flickrPhotoContext], completionHandler: @escaping (AsyncResult<[flickrPhotoContext]>) -> ()) {
//        var responseJson:NSDictionary = NSDictionary.init();
//        var responseString:String?;
//        var photoURL:URL?;
//        
//        // prepare API methode for http request execution
//        let apiRequest:flickrAPIRequest = FlickrHelperMethodes.flickrGeneratePhotoThumbnailWithURLRequest(photoTag: photoTag);
//        
//        
//    }
    
    
//    func flickrGetThumbnailPhotos(photoContextArray: [flickrPhotoContext], completionHandler: @escaping (AsyncResult<[flickrPhotoContext]>) -> ()) {
//        var responseJson:NSDictionary = NSDictionary.init();
//        var responseString:String?;
//        var photoURL:URL?;
//        
//        //for photoContext in photoContextArray {
//        for i in 0..<(photoContextArray.count-1) {
//            // prepare API methode for http request execution
//            let apiRequest:flickrAPIRequest = FlickrHelperMethodes.flickrGeneratePhotoSizesRequest(photoId: photoContextArray[i].id)
//            
//            super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
//                DispatchQueue.main.sync {
//                    switch flickrAPIResponse {
//                    case .Success(let flickrResponse):
//                        responseString =  String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
//                        print(responseString!);
//                        
//                        // Parse response JSON data, check for status
//                        responseJson = FlickrHelperMethodes.flickrGetJSONDictionary(data: flickrResponse.responseData!)!
//                        
//                        let photoSizes:NSArray = ((responseJson["sizes"] as? NSDictionary)?.value(forKey: "size") as? NSArray)!;
//                        for sizeInfo in photoSizes {
//                            if (((sizeInfo as! NSDictionary).value(forKey: "label")) as! String == "Thumbnail") {
//                                photoURL = URL.init(string: (((sizeInfo as! NSDictionary).value(forKey: "source")) as! String))!;
//
//                                // get thumbnail photo and store it into photo Context
//                                self.flickrDownloadPhotoFromURL(photoURL: photoURL!) { (flickrPhotoResponse) in
//                                    switch flickrPhotoResponse {
//                                    case .Success(let thumbnailPhoto):
//                                        // search po id-u
//                                        photoContextArray[i].thumbnailPhoto = thumbnailPhoto;
//                                        break;
//                                    case .Failure(let downloadPhotoError):
//                                        print("Error while dowloaading thumbnail photo: \(downloadPhotoError)");
//                                    }
//                                }
//                            }
//                        }
//                        
//                        break;
//                    case .Failure(let flickrResponseError):
//                        print("Error! API methodeL flickrGetThumbnailPhotos: \(flickrResponseError)");
//                        completionHandler(AsyncResult.Failure(flickrResponseError));
//                    }
//                }
//            }
//        }
//    }
    
    
    /*
     Photo Download methodes
     */
    
    func flickrDownloadPhotoFromURL(photoURL: URL, completionHandler: @escaping (AsyncResult<Data>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = FlickrHelperMethodes.flickrGenerateDownloadPhotoURLRequest(photoURL: photoURL);
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    if flickrResponse.responseData != nil {
                        print("Response [flickrDownloadPhotoFromURL]: image downloaded");
                    }
                    else {
                        print("Error, downloaded image is nil!");
                    }

                    
                    completionHandler(AsyncResult.Success(flickrResponse.responseData!));
                    break;
                    
                case .Failure(let flickrResponseError):
                    print("completionHandler: \(flickrResponseError)");
                    
                    completionHandler(AsyncResult.Failure(flickrResponseError));
                    break;
                }
            }
        }
        
    }
    
    
    func flickrDownloadPhotoFromURLUsingPhotoContext(photoContext: flickrPhotoContext, completionHandler: @escaping (AsyncResult<Data>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest =  FlickrHelperMethodes.flickrGenerateDownloadPhotoFromPhotoContextURLRequest(photoContext: photoContext);
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    if flickrResponse.responseData != nil {
                        print("Response [flickrDownloadPhotoFromURLUsingPhotoContext]: image downloaded");
                    }
                    else {
                        print("Error, downloaded image is nil!");
                    }

                    
                    completionHandler(AsyncResult.Success(flickrResponse.responseData!));
                    break;
                    
                case .Failure(let flickrError):
                    print("completionHandler: \(flickrError)");

                    completionHandler(AsyncResult.Failure(flickrError));
                    break;
                }
            }
        }
    }
}
