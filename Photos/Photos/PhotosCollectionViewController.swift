//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    var photos: [Photo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        self.collectionView?.backgroundColor = UIColor.whiteColor()
    }

    /* 
     * IMPLEMENT ANY COLLECTION VIEW DELEGATE METHODS YOU FIND NECESSARY
     * Examples include cellForItemAtIndexPath, numberOfSections, etc.
     */
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotoCell
        if((photos) != nil){
            dispatch_async(dispatch_get_main_queue()) {
                self.loadImageForCell(self.photos[indexPath.row], imageView: cell.image)
            }
        }
        cell.image.sizeToFit()
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if((photos) != nil) {
            return photos.count
        } else {
            return 0
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            let screen = UIScreen.mainScreen().bounds.size
            return CGSizeMake(screen.width*0.48, screen.height*0.33)
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showPhotoDetailSegue", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showPhotoDetailSegue") {
            let indexPath = sender as! NSIndexPath
            let photoDetailView = segue.destinationViewController.view as! PhotoDetailView
            if(photos != nil) {
                loadImageForCell(photos[indexPath.row], imageView: photoDetailView.imageView)
                let formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .MediumStyle
                photoDetailView.dateLabel.text! += formatter.stringFromDate(photos[indexPath.row].datePosted)
                photoDetailView.usernameLabel.text! += photos[indexPath.row].username
                photoDetailView.numLikesLabel.text! += photos[indexPath.row].likes.description
                photoDetailView.photo = photos[indexPath.row]
                if(photos[indexPath.row].liked == false) {
                    photoDetailView.likeButton.setTitle("♡", forState: .Normal)
                } else {
                    photoDetailView.likeButton.setTitle("❤", forState: .Normal)
                }
            }
        }
    }
    
    /* Creates a session from a photo's url to download data to instantiate a UIImage.
       It then sets this as the imageView's image. */
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photo.url)!) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                imageView.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.collectionView!.reloadData()
    }
    
}

