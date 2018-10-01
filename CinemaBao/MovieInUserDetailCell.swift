//
//  MovieInUserDetailCell.swift
//  CinemaBao
//
//  Created by macOS Sierra on 10/1/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieInUserDetailCell: UICollectionViewCell {

    @IBOutlet weak var imageMovie: UIImageView!
  @IBOutlet weak var lblMovieName: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

    func setDatainCell(_ movie: Movie) {
        lblMovieName?.text = movie.name
        Alamofire.request("https://cinema-hatin.herokuapp.com" + movie.posterURL).responseImage(completionHandler: { (response) in
            print(response)
            switch response.result {
            case .success:
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        self.imageMovie?.image = image
                    }
                }
            case .failure:
                print("Error")
                return
            }
        })
    }

}
