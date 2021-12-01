//
//  MoviePageViewController.swift
//  Movies
//
//  Created by Михаил Зиновьев on 01.12.2021.
//

import UIKit

class MoviePageViewController: UIViewController {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imdbRatingLabel: UILabel!
    
    var page: MoviePage?

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }
    
    private func setupViews() {
        titleLabel.text = page?.title
        descriptionLabel.text = page?.plot
        if let safeRating = page?.imdbRating {
            imdbRatingLabel.text = "imdb \(safeRating)"
        } else {
            imdbRatingLabel.isHidden = true
        }
        imdbRatingLabel.text = "imdb \( page?.imdbRating ?? "")"
        
        DispatchQueue.global().async {
            guard let stringURL = self.page?.poster else { return }
            guard let url = URL(string: stringURL) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
            }
        }
    }
}
