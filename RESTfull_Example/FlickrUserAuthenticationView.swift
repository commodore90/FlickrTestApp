//
//  flickrUserAuthenticationView.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/14/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrUserAuthenticationViewController: UIViewController, UIWebViewDelegate {

    private var webViewRequest: URLRequest?
    
    @IBOutlet weak var flickrWebView: UIWebView!
    
    let flicktRestFullAPIobj:flickrRestFullAPIManager = flickrRestFullAPIManager.init();
    
    public var flickrAuthenticationURLstr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        flickrWebView.delegate = self;
        self.flickrWebView.scalesPageToFit = true
        self.flickrWebView.contentMode = .scaleToFill
        self.flickrWebView.isOpaque = false
        self.flickrWebView.backgroundColor = UIColor.clear
        
        // prepare User Authorization URL
        let requestToken:FlickrRequestToken = FlickrSessionAuthorization.sharedInstance.getRequestToken();
        let apiRequest:flickrAPIRequest = FlickrHelperMethodes.flickrGenerateUserAuthorizationRequest(requestToken: requestToken);
        
        let requestURL:URL     = apiRequest.getURL();
        let request:URLRequest = URLRequest(url: requestURL);

        self.flickrWebView.loadRequest(request)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: UIWebViewDelegate
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Authentication Web view did start loading!");
        self.flickrWebView.isHidden = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Authentication Web view did finish load");
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription);
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var userAuthorization:FlickrUserAuthorization?;
        
        if ((request.url?.absoluteString.range(of: FlickrConstants.kOauthCallback)) != nil) {
            var parsedDictionary:[String:String] = FlickrHelperMethodes.flickrResponseStringParser(responseString: (request.url?.absoluteString)!, flickrParseArguments: ["oauth_verifier"]);
            
            userAuthorization = FlickrUserAuthorization.init(oauthVerifier: parsedDictionary["oauth_verifier"]!);
            FlickrSessionAuthorization.sharedInstance.setUserAuthorizatrion(userAuthorization: userAuthorization!)
            print(request);
            
            self.flicktRestFullAPIobj.getOAuthAccessToken(
                requestToken: FlickrSessionAuthorization.sharedInstance.getRequestToken(),
                userAuthorization: FlickrSessionAuthorization.sharedInstance.getUserAuthorization()
            ) { (accessTokenCompletion) in
                
                switch accessTokenCompletion {
                case .Success( _):
                    print("Sueccessfuly Completed getOauthAccessToken!");
                    let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FlickrPhotoSelectViewController");
                    
                    self.navigationController?.pushViewController(controller, animated: true);
                    self.navigationController?.setViewControllers([controller], animated: true);
                    
                    break;
                case .Failure(let oauthError):
                    print("flickr oauth error! \(oauthError)");
                    break;
                }
                
            }
            
            return false
        }
        
        return true
    }
    
}
