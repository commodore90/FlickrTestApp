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
    /// - completionHandler("Array of Photo contexts -> [FlickrPhotoContext]");
    
    func flickrPhotosSearchByTag(photoTag:String, completionHandler: @escaping (AsyncResult<[FlickrPhotoContext]>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:FflickrAPIRequest = FlickrHelperMethodes.fickrGeneratePhotosSearchRequest(photoTag: photoTag);
        var responseString:String?;
        var responseJson:NSDictionary = NSDictionary.init();
        var photoStatusArray:[FlickrPhotoContext] = [];
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (FlickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch FlickrAPIResponse {
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
                            let photoInfo:FlickrPhotoInfo = FlickrPhotoInfo.init(
                                originalFormat: String(describing: photoResponse["originalformat"]!),
                                title: String(describing: photoResponse["title"]!),
                                dateTaken: String(describing: photoResponse["datetaken"]!)
                            );
                            
                            let photoContext:FlickrPhotoContext = FlickrPhotoContext.init(
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
    
    func flickrGetPhotoInfo(photoContext: FlickrPhotoContext, completionHandler: @escaping (AsyncResult<FlickrPhotoInfo>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:FflickrAPIRequest = FlickrHelperMethodes.flickrGeneratePhotoInfoRequest(photoId: photoContext.id);
        var responseString:String?;
        var responseJson:NSDictionary = NSDictionary.init();
        let photoInfo:FlickrPhotoInfo = FlickrPhotoInfo.init();
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (FlickrAPIResponse) in
            DispatchQueue.main.async {
                switch FlickrAPIResponse {
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
                    print("Get Photo Info Error: \(flickrError)");
                    break;
                }
            }
        }
    }

    
    /*
     Photo Download methodes
     */
    
    func flickrDownloadPhotoFromURL(photoURL: URL, completionHandler: @escaping (AsyncResult<FlickrAPIResponse>) -> ()) { // Data
        // prepare API methode for http request execution
        let apiRequest:FflickrAPIRequest = FlickrHelperMethodes.flickrGenerateDownloadPhotoURLRequest(photoURL: photoURL);
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (FlickrAPIResponse) in
            DispatchQueue.main.async {
                switch FlickrAPIResponse {
                case .Success(let flickrResponse):
                    
                    if flickrResponse.responseData != nil {
                        print("Response [flickrDownloadPhotoFromURL]: image downloaded");
                    }
                    else {
                        print("Error, downloaded image is nil!");
                    }
                        completionHandler(AsyncResult.Success(flickrResponse));  // flickrResponse.responseData!
                    break;
                    
                case .Failure(let flickrResponseError):
                
                    print("completionHandler: \(flickrResponseError)");
                    completionHandler(AsyncResult.Failure(flickrResponseError));
                    break;
                }
            }
        }
    }
    
    
    func flickrDownloadPhotoFromURLUsingPhotoContext(photoContext: FlickrPhotoContext, completionHandler: @escaping (AsyncResult<Data>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:FflickrAPIRequest =  FlickrHelperMethodes.flickrGenerateDownloadPhotoFromPhotoContextURLRequest(photoContext: photoContext);
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (FlickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch FlickrAPIResponse {
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
