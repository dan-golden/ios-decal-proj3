//
//  PhotoDetailViewController.swift
//  Photos
//
//  Created by Daniel Golden on 11/15/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotoDetailView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var photo: Photo?
    
    @IBAction func likedButtonPressed(sender: AnyObject) {
        if(photo?.liked == false) {
            likeButton.setTitle("❤", forState: .Normal)
        } else {
            likeButton.setTitle("♡", forState: .Normal)
        }
        photo?.liked = !photo!.liked
    }
}
