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
    /// - photoTag("photo search criterium");
    func flickrPhotosSearchByTag(photoTag:String, completionHandler: @escaping (AsyncResult<[flickrPhotoContext]>) -> ()) {
        // prepare API methode for http request execution
        let apiRequest:flickrAPIRequest = flickrHelperMethodes.fickrGeneratePhotosSearchRequest(photoTag: photoTag);
        // var flickrLoginResponse:flickrResponseDictionary = flickrResponseDictionary.init();
        var responseString:String?;
        var responseJson:NSDictionary = NSDictionary.init() // [String:Any]();

        var photoStatusArray:[flickrPhotoContext] = [];
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
                    responseString = String(data: flickrResponse.responseData!, encoding: String.Encoding.utf8)!;
                    print("Response Data : " + responseString!);
                    
                    // Parse response JSON data, check for status -> stat : ok
                    
                    responseJson = flickrHelperMethodes.flickrGetJSONDictionary(data: flickrResponse.responseData!)!
                    
                    // Parse JSON Dictionary, and store: id, secret, farm, server for each photo
                    
                    // prebaci u [String:Any] tip i parsiranje i mapiranje -> JSONSerializer, jer ovako nemam kontrolu nad tipovima
                    
                    if let photoNumberInResponse:String = ((responseJson["photos"] as? NSDictionary)?.value(forKey: "total")) as? String {
                        let photoNum:Int = Int(photoNumberInResponse)!;
                        for i in 0..<photoNum {
                            let photoResponse:NSDictionary = (((( ((responseJson["photos"] as? NSDictionary)?.value(forKey: "photo")) as? NSArray)?[i]) as? NSDictionary))!
                            let photoContext:flickrPhotoContext = flickrPhotoContext.init(
                                id:     String(describing: photoResponse["id"]!),     // as? String)!,
                                secret: String(describing: photoResponse["secret"]!), // as! String,
                                server: String(describing: photoResponse["server"]!), // as! String,
                                farm:   String(describing: photoResponse["farm"]!)     // (photoResponse["farm"]! as! String)!
                            )
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
    
//    func flickrGetPhotoInfo() {       // provide informations about format....
//        
//    }
    
    func flickrDownloadPhotoFromURL(photoContext: flickrPhotoContext, completionHandler: @escaping (AsyncResult<Data>) -> ()) {
        
        // get
        
        let apiRequest:flickrAPIRequest =  flickrHelperMethodes.flickrGenerateDownloadPhotoFromURLReQuest(photoContext: photoContext);
            // flickrAPIRequest.init(httpMethod: RequestMethod.GET, host: "farm3.staticflickr.com", path: "/2886/33548524215_85ff717bee.jpg", headers: nil, query: nil, body: nil);// flickrHelperMethodes.fickrGeneratePhotoDowbloadRequest();
        
        super.flickrMakeUnauthorizedApiCallWithRequest(apiRequest: apiRequest) { (flickrAPIResponse) in
            
            DispatchQueue.main.async {
                switch flickrAPIResponse {
                case .Success(let flickrResponse):
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
