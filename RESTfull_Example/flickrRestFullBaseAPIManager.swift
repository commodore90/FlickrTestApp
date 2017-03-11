//
//  flickrRestFullBaseAPIManager.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/2/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import Foundation

class flickrRestFullBaseAPIManager {
    
    func flickrCreateRequestURL() {
        
    }
    
    private func createRequestURLfromFlickrAPIRequest(apiRequest:flickrAPIRequest) -> URL {         // this should be URL extension method
        var urlComponent:URLComponents = URLComponents.init();
        var urlString:String = "";
        var i:Int = 0;
        
        urlComponent.scheme      = flickrConstants.kBaseHostURLScheme;
        urlComponent.host        = flickrConstants.kBaseHostURL;
        urlComponent.path        = apiRequest.path;
        
        urlString += String((urlComponent.url?.absoluteString)!) + "?";
        
        urlComponent.queryItems  = apiRequest.query;
        
        
        for query in apiRequest.query! {
            urlString += String(query.name + "=" + query.value!)!;
            
            if (i != (apiRequest.query?.count)!-1) {
                urlString += "&";
            }
            
            i += 1;
        }
        
        let url:URL = URL(string: urlString)!;
        
        return url;
    }
    
    
    // -> URLSessionDataTask?
    
    func flickrMakeUnauthorizedApiCallWithRequest(apiRequest:flickrAPIRequest, completionHandler: @escaping (AsyncResult<flickrAPIResponse>) -> ()) {
        let config = URLSessionConfiguration.default;
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
            if (responceString?.range(of: flickrConstants.kFlickrJSONmark) != nil) {
            
                // Convert server json response to NSDictionary
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        // Print out dictionary
                        print(convertedJsonIntoDict)
                        
                        // Get value by key
                        let oauth_token = convertedJsonIntoDict["oauth_token"] as? String
                        if (oauth_token != nil) {
                            print(oauth_token!)
                        }
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                let flickrResponse: flickrAPIResponse = flickrAPIResponse(responseFormat: ResponseFormat.JSON, responseError: error, responseData: responseData, responseCode: statusCode);
                completionHandler(AsyncResult.Sucess(flickrResponse));
            }
            else {
                let flickrResponse: flickrAPIResponse = flickrAPIResponse(responseFormat: ResponseFormat.TEXT, responseError: error, responseData: responseData, responseCode: statusCode);
                completionHandler(AsyncResult.Sucess(flickrResponse));
            }
            
            DispatchQueue.main.async {
                //Update UI
            }
        }
        task.resume()
        
        // return task;
    }
    
    func flickrMakeAuthorizedApiCallWithRequest() {
        
    }
    
}
