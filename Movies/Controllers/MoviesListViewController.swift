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
    
//MARK: - Life Cicle
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
    
    func updateUI(needEmptyVIew: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.showEmptyView(needEmptyVIew)
            self?.tableView.reloadData()
        }
    }
    
    func showEmptyView(_ solution: Bool) {
        tableView.isHidden = solution
        emptyView.isHidden = !solution
    }
}

//MARK: - UITableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard movieList.indices.contains(indexPath.row) else { return UITableViewCell() }
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: MovieTableViewCell.identifier,
                    for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: movieList[indexPath.row])
        return cell
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
            updateUI(needEmptyVIew: false)
        } else {
            showEmptyView(true)
        }
    }
    
    func didFailWithError(error: Error?) {
        //todo search alert woth error info
        print("delegate didFailWithError \(String(describing: error))")
        updateUI(needEmptyVIew: true)
    }
}
