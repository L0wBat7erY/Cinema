//
//  MovieInUserDetailCell.swift
//  CinemaBao
//
//  Created by macOS Sierra on 10/1/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import SDWebImage

class MovieInUserDetailCell: UICollectionViewCell {
  
  @IBOutlet weak var imageMovie: UIImageView!
  @IBOutlet weak var lblMovieName: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  func setDatainCell(_ movie: Movie) {
    lblMovieName?.text = movie.name
    
    let urlPosterURL = URL(string: "https://cinema-hatin.herokuapp.com" + movie.posterURL)
    imageMovie.sd_setImage(with: urlPosterURL, placeholderImage: UIImage(named: "ProfileMovie"))
  }
}
