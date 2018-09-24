//
//  CustomViewCell.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CustomViewCell: UITableViewCell {

    @IBOutlet weak var profileMovie: UIImageView!
    @IBOutlet weak var idPhim: UILabel!
    @IBOutlet weak var theLoai: UILabel!
    @IBOutlet weak var releaseMovie: UILabel!
    @IBOutlet weak var iconTheLoai: UIImageView!
    @IBOutlet weak var iconIDMovie: UIImageView!
    @IBOutlet weak var iconReleaseDate: UIImageView!
    @IBOutlet weak var tenPhim: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconTheLoai.image = UIImage.fontAwesomeIcon(name: .camera, style: .solid, textColor: .green, size: CGSize(width: 30, height: 30))
        iconIDMovie.image = UIImage.fontAwesomeIcon(name: .info, style: .solid, textColor: .green, size: CGSize(width: 30, height: 30))
        iconReleaseDate.image = UIImage.fontAwesomeIcon(name: .calendar, style: .solid, textColor: .green, size: CGSize(width: 30, height: 30))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDatainCell(_ movie: Movie) {
        idPhim.text = movie._id
        theLoai.text = movie.genre
        tenPhim.text = movie.name
    }
    
    
    
}
