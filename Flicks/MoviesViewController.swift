//
//  ViewController.swift
//  Flicks
//
//  Created by Nader Neyzi on 9/13/17.
//  Copyright © 2017 Nader Neyzi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var moviesTable: UITableView!
    var movies: [NSDictionary] = []

    var endpoint: String!
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        moviesTable.delegate = self
        moviesTable.dataSource = self
        moviesTable.rowHeight = 166

        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        moviesTable.insertSubview(refreshControl, at: 0)

        getMovies()
    }

    func getMovies() {
        let getMoviesHud = MBProgressHUD.showAdded(to: self.view, animated: true)

        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"

        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in

            if error != nil {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    getMoviesHud.hide(animated: true)
                    let errorHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    errorHud.mode = MBProgressHUDMode.text
                    errorHud.label.text = "Something went wrong!"
                    errorHud.minShowTime = 5
                    errorHud.hide(animated: true)
                }
            } else {
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")

                        self.movies = responseDictionary.value(forKey: "results") as! [NSDictionary]
                    }
                }
                DispatchQueue.main.async {
                    getMoviesHud.hide(animated: true)
                    self.refreshControl.endRefreshing()
                    self.moviesTable.reloadData()
                }
            }

        });
        task.resume()
    }

    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        getMovies()
    }

    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTable.dequeueReusableCell(withIdentifier: "MoviesCell") as! MoviesTableViewCell

        let movie = movies[indexPath.row]
        cell.movieTitleLabel?.text = movie.value(forKey: "title") as? String
        cell.movieDescriptionLabel?.text = movie.value(forKey: "overview") as? String

        let imageBaseStr = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie.value(forKey: "poster_path") as? String {
            let imageUrlStr = imageBaseStr + posterPath
            if let imageUrlStr = URL(string: imageUrlStr) {
                cell.movieImage.setImageWith(imageUrlStr)
            }
        }
        
        return cell
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MoviesTableViewCell
        let indexPath = moviesTable.indexPath(for: cell)

        let detailViewController = segue.destination as! DetailsViewController
        detailViewController.movie = movies[indexPath!.row]

    }

}

