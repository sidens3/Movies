//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Михаил Зиновьев on 27.11.2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
        
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        movieImage.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        movieImage.image = nil
    }
    
    func configure(with movie: Movie) {
        movieTitle.text = movie.Title
        movieYear.text = movie.Year
        
        DispatchQueue.global().async {
            guard let stringURL = movie.Poster else { return }
            guard let url = URL(string: stringURL) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.movieImage.image = UIImage(data: imageData)
            }
        }
    }
}
