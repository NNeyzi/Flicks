//
//  Movie.swift
//  
//
//  Created by Nader Neyzi on 9/16/17.
//
//

import UIKit

class Movie: NSObject {

    var title: String?
    var overview: String?
    var posterImageUrlHigh: URL?
    var posterImageUrlMedium: URL?
    var posterImageUrlLow: URL?
    var backdropImageUrlHigh: URL?
    var backdropImageUrlMedium: URL?
    var backdropImageUrlLow: URL?

    init(dictionary: NSDictionary) {
        self.title = dictionary.value(forKey: "title") as? String
        self.overview = dictionary.value(forKey: "overview") as? String

        if let posterPath = dictionary.value(forKey: "posterPath") as? String {
            self.posterImageUrlHigh = URL(string: TheMovieDBApi.imageBaseStr + "original" + posterPath)
            self.posterImageUrlMedium = URL(string: TheMovieDBApi.imageBaseStr + "w500" + posterPath)
            self.posterImageUrlLow = URL(string: TheMovieDBApi.imageBaseStr + "w45" + posterPath)
        }

        if let backdropPath = dictionary.value(forKey: "backdropPath") as? String {
            self.backdropImageUrlHigh = URL(string: TheMovieDBApi.imageBaseStr + "original" + backdropPath)
            self.backdropImageUrlMedium = URL(string: TheMovieDBApi.imageBaseStr + "original" + backdropPath)
            self.backdropImageUrlLow = URL(string: TheMovieDBApi.imageBaseStr + "original" + backdropPath)
        }
    }
    
}
