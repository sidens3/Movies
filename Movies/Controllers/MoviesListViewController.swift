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
    }
    
    func updateUI(needEmptyView: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.showEmptyView(needEmptyView)
            self?.tableView.reloadData()
        }
    }
    
    func showEmptyView(_ solution: Bool) {
        tableView.isHidden = solution
        emptyView.isHidden = !solution
    }
    
    func fetchMovies(from url: String) {
        NetworkManager.shared.fetchMovies(with: url) { result in
            switch result {
            case .success( let searchResult):
                if searchResult.totalResults != "0" {
                    self.movieList = searchResult.search
                    self.updateUI(needEmptyView: false)
                } else {
                    self.showEmptyView(true)
                }
            case .failure(let error):
                self.showAlert(for: error)
                self.updateUI(needEmptyView: true)
            }
        }
    }
    
    func fetchMoviePage(for id: String) {
        NetworkManager.shared.fetchMoviePage(for: id) { result in
            switch result {
            case .success(let page):
                
                self.performSegue(withIdentifier: "showMoviePage", sender: page)
                
            case .failure(let error):
                self.showAlert(for: error)
                self.updateUI(needEmptyView: true)
            }
        }
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
        guard movieList.indices.contains(indexPath.row) else { return }
        
        fetchMoviePage(for: movieList[indexPath.row].imdbID)
    }
}

//MARK: - UISearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMovies(from: searchBar.text ?? "")
        view.endEditing(true)
    }
}

// MARK: - Alert Controller
private extension MoviesListViewController {
    func showAlert(for error: NetworkError) {
        var errorText = "unknown error"
        
        switch error {
        case .invalidURL:
            errorText = "Invalid search request"
        case .noData:
            errorText = "No data by search request"
        case .decodingError:
            errorText = "Error occured in parsing"
        }
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: errorText,
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

//MARK: - Navigation
extension MoviesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMoviePage", let page = sender as? MoviePage else { return }
        
        let moviePageVC = segue.destination as? MoviePageViewController
        moviePageVC?.page = page
    }
}
