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
                
                // data is ready, reload data in table
                self.flickrRefreshPhotoTable();
                break;
            case .Failure(let getPhotoContextForKindError):
                print("Error: \(getPhotoContextForKindError)");
                break;
            }
        };
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

    func flickrRefreshPhotoTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    /*
    Tabel View Delegate methodes
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
            
            // let flickrPhotoViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FlickrPhotoViewController") as! FlickrPhotoViewController;
            // self.navigationController?.pushViewController(self.photoView!, animated: true);
            
            self.photoView?.photoContextToPresent = self.selectedCell?.photoContext;
            
        }
        else {
            print("Error, Cell Selection!");
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrool")
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if ((segue.identifier?.range(of: "flickrShowFullSizePhoto")) != nil) {
            
            self.photoView = segue.destination as! FlickrPhotoViewController;
            self.photoView?.photoSelectViewReturnDelegate = self;
            
        }
    }
    
    /*
     SelectView return protocol methodes
     */
    func requestLoadingSpinerStop() {
        
        self.spinnerStopRequest = true;
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
}
