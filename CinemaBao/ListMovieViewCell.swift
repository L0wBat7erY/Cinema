//
//  CustomViewCell.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import FontAwesome_swift
import PullToRefresh
import Alamofire
import AlamofireImage

class ListMovieViewCell: UITableViewCell {

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
        
        iconTheLoai.image = UIImage.fontAwesomeIcon(name: .video, style: .solid, textColor: .blue, size: CGSize(width: 30, height: 30))
        iconIDMovie.image = UIImage.fontAwesomeIcon(name: .info, style: .solid, textColor: .blue, size: CGSize(width: 30, height: 30))
        iconReleaseDate.image = UIImage.fontAwesomeIcon(name: .calendar, style: .solid, textColor: .blue, size: CGSize(width: 30, height: 30))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setDatainCell(_ movie: Movie) {
        idPhim.text = movie.content
        theLoai.text = movie.genre
        tenPhim.text = movie.name
        Alamofire.request("https://cinema-hatin.herokuapp.com" + movie.posterURL).responseImage(completionHandler: { (response) in
            print(response)
            switch response.result {
            case .success:
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        self.profileMovie.image = image
                    }
                }
            case .failure:
                print("Error")
                return
            }
        })
        releaseMovie.text = convertTimestampToHumanDate(timestamp: movie.releaseDate)
    }
    
    func convertTimestampToHumanDate(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy"
        let strDate = formatterDate.string(from: date)
        return strDate
    }
    
    
}
