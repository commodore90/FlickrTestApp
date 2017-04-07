//
//  flickrRestFullBaseAPIManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/2/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

struct flickrBaseAPIManagerError: Error {
    enum ErrorKind {
        case badResponse
    }
}

class FlickrRestFullBaseAPIManager {
    
    func flickrCreateRequestURL() {
        
    }
    
    /*
        Crate Request URL from FflickrAPIRequest
     */
    private func createRequestURLfromFlickrAPIRequest(apiRequest:FflickrAPIRequest) -> URL {         // this should be URL extension method
        var urlComponent:URLComponents = URLComponents.init();
        var urlString:String = "";
        var i:Int = 0;
        
        urlComponent.scheme      = FlickrConstants.kBaseHostURLScheme;
        urlComponent.host        = apiRequest.host; // FlickrConstants.kBaseHostURL;
        urlComponent.path        = apiRequest.path;
        
        urlString += String((urlComponent.url?.absoluteString)!) + "?";
        
        urlComponent.queryItems  = apiRequest.query;
        
        if (apiRequest.query != nil) {
            for query in apiRequest.query! {
                urlString += String(query.name + "=" + query.value!)!;
                
                if (i != (apiRequest.query?.count)!-1) {
                    urlString += "&";
                }
                
                i += 1;
            }
        }
        
        let url:URL = URL(string: urlString)!;
        
        return url;
    }
    
    /*
        Fire Unauthorised http API call using FflickrAPIRequest.
        Return Response using completionHandler closure
     */
    func flickrMakeUnauthorizedApiCallWithRequest(apiRequest:FflickrAPIRequest, completionHandler: @escaping (AsyncResult<FlickrAPIResponse>) -> ()) {
        let config = URLSessionConfiguration.default;
        // let cache: URLCache = URLCache.init(memoryCapacity: 200 * 1024 * 1024, diskCapacity: 400 * 1024 * 1024, diskPath: nil)
        // URLCache.shared = cache
        // config.urlCache = cache
        // config.timeoutIntervalForResource = 2.0;
        let session = URLSession(configuration: config);
        let request:NSMutableURLRequest = NSMutableURLRequest.init(); // = NSMutableURLRequest(url: callbackURL);
        
        // set request URL
        request.url = self.createRequestURLfromFlickrAPIRequest(apiRequest: apiRequest);

        // set request http method
        request.httpMethod = apiRequest.httpMethod.rawValue;

        // set request headers
        if ((apiRequest.headers != nil) && ((apiRequest.headers?.count)! > 0)) {
            for (key, value) in apiRequest.headers! {
                request.setValue(value as? String, forHTTPHeaderField: key);                // this is wrong!
            }
        }
        
        // set request body
        if (apiRequest.body != nil) {
            request.httpBody = apiRequest.body;
        }
        
        // execute http request task
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // check for error
            guard error == nil else {
                print("error = \(error)");
                completionHandler(AsyncResult.Failure(error));
                return
            }
            
            // check if respose data exist
            guard let responseData = data else {
                print("Error: flickrMakeUnauthorizedApiCallWithRequest() did not receive data!");
                return
            }
            
            // cast responce data to string
            let responceString = String(data: data!, encoding: String.Encoding.utf8);
            let statusCode = (response as! HTTPURLResponse).statusCode;
            
            // check if responce is in JSON or TEXT format
            if (responceString?.range(of: FlickrConstants.kFlickrJSONmark) != nil) {
                
                let flickrResponse:FlickrAPIResponse = FlickrAPIResponse(
                    responseFormat: ResponseFormat.JSON,
                    responseError: error,
                    responseData: responseData,
                    responseCode: statusCode,
                    responseRequestURL: response?.url
                );
                completionHandler(AsyncResult.Success(flickrResponse));
            }
            else {
                let flickrResponse: FlickrAPIResponse = FlickrAPIResponse(
                    responseFormat: ResponseFormat.TEXT,
                    responseError: error,
                    responseData: responseData,
                    responseCode: statusCode,
                    responseRequestURL: response?.url
                );
                completionHandler(AsyncResult.Success(flickrResponse));
            }
            
        }
        task.resume()
    
    }
    
    /*
        Fire Authorised http API call using FflickrAPIRequest.
        Return Response using completionHandler closure
     */
    func flickrMakeAuthorizedApiCallWithRequest() {
        
    }
    
}
