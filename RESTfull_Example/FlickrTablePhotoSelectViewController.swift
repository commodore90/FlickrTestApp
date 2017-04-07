//
//  FlickrTablePhotoSelectViewControllerTableViewController.swift
//  RESTfull_Example
//
//  Created by Stefan Miskovic on 3/30/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

import UIKit

class FlickrTablePhotoSelectViewController: UITableViewController, FlickrTablePhotoSelectViewProtocol, FlickrPhotoSelectViewReturnProtocol {
    
    // MARK: Delegates
    var stateManagerDelegate : FlickrTablePhotoSelectViewStateManagerProtocol?;
    
    // Flickr Spinner
    var loadingSpinner:FlickrProgressIndicator?;
    var spinnerStopRequest:Bool = false;
    
    // Selected cell
    var selectedCell:FlickrTablePhotoSelectViewCell?;
    
    // photo View
    var photoView:FlickrPhotoViewController?;
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Spinner
        loadingSpinner = FlickrProgressIndicator.init(inview: self.view, loadingViewColor: UIColor.gray, indicatorColor: UIColor.red, msg: "Loading Photo");
        self.view.addSubview(loadingSpinner!)
        self.loadingSpinner!.start();
        
        if (spinnerStopRequest) {
            self.loadingSpinner?.stop();
            self.spinnerStopRequest = false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set table View Delegate
        self.stateManagerDelegate!.tablePhotoSelectViewDelegate = self;
        
        // get all photo contexts which satisfy photo search criterium -> photoTag
        self.stateManagerDelegate!.getPhotosContextArrayForKind() { (getPhotosContextArrayFinished) in
            switch (getPhotosContextArrayFinished) {
            case .Success:
                
                // Stop spinner
                self.loadingSpinner!.stop();
                
                // Data is ready, reload data in table
                self.flickrRefreshPhotoTable();
                
                break;
            case .Failure(let getPhotoContextForKindError):
                print("Error: \(getPhotoContextForKindError)");
                break;
            }
        };
        
    }

    // MARK: - Table view data source

    func flickrRefreshPhotoTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    /*
    Table View Delegate methodes
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowNumber:Int = self.stateManagerDelegate!.photoContextArray?.count {
            return rowNumber;
        }
        else {
            return 0;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return (self.stateManagerDelegate?.tableView(tableView, cellForRowAt: indexPath))!;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
            
            self.selectedCell = currentCell as? FlickrTablePhotoSelectViewCell;
            self.photoView?.photoContextToPresent = self.selectedCell?.photoContext;
        }
        else {
            print("Error, Cell Selection!");
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         self.flickrRefreshPhotoTable();
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if ((segue.identifier?.range(of: "flickrShowFullSizePhoto")) != nil) {
            
            self.photoView = segue.destination as? FlickrPhotoViewController;
            self.photoView?.photoSelectViewReturnDelegate = self;
        }
    }
    
    /*
     SelectView return protocol methodes
     */
    
    func requestLoadingSpinerStop() {
        
        self.spinnerStopRequest = true;
    }
    
}
