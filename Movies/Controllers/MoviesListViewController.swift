//
//  MoviesListViewController.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIStackView!
    
    private var movieListManager = MovieListManager()
    private var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

//MARK: - Private Methods
private extension MoviesListViewController {
    func setupViews() {
        tableView.separatorStyle = .none
        tableView.register(MovieTableViewCell.nib, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        
        movieListManager.delegate = self
    }
    
    func showEmptyView(_ solution: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = solution
            self?.emptyView.isHidden = !solution
        }
    }
}

//MARK: - UITableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected item by index \(indexPath.row)")
    }
}

//MARK: - UISearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("searchBarSearchButtonClicked with search text \(String(describing: searchBar.text))")
        
        movieListManager.fetchMovies(with: searchBar.text ?? "")
        view.endEditing(true)
    }
}

extension MoviesListViewController: MovieListManagerDelegate {
    func didUpdateMovieList(_ movieListManager: MovieListManager, movieSearch: MovieSearch) {
        //update tableVIew or search empty view
        print("delegate didUpdateMovieList")
        if movieSearch.totalResults != "0" {
            movieList = movieSearch.Search
            showEmptyView(false)
        } else {
            showEmptyView(true)
        }
    }
    
    func didFailWithError(error: Error) {
        //todo search alert woth error info
        print("delegate didFailWithError \(error)")
    }
}
