//
//  DetailsViewController.swift
//  Flicks
//
//  Created by Nader Neyzi on 9/16/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: detailsView.frame.origin.y + detailsView.frame.size.height)

        titleLabel.text = movie.value(forKey: "title") as? String
        descriptionLabel.text = movie.value(forKey: "overview") as? String
        descriptionLabel.sizeToFit()

        let imageBaseStr = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie.value(forKey: "poster_path") as? String {
            let imageUrlStr = imageBaseStr + posterPath
            if let imageUrlStr = URL(string: imageUrlStr) {
                posterImageView.setImageWith(imageUrlStr)
            }
        }

    }

}
