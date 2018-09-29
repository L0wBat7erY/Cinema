//
//  FilmInfo.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/25/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class FilmInfo: UIViewController {
    
    
    @IBOutlet weak var lblNameMovie: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imagePosterMovie: UIImageView!
    
    var dataFromHere = Movie()

    
    
    
    @IBAction func backList(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func convertTimestampToHumanDate(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy"
        let strDate = formatterDate.string(from: date)
        return strDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNameMovie.text = dataFromHere.name
        lblGenre.text = dataFromHere.genre
        lblReleaseDate.text = convertTimestampToHumanDate(timestamp: dataFromHere.releaseDate)
        lblContent.text = dataFromHere.content
        
        print(dataFromHere.posterURL)
        
        Alamofire.request("https://cinema-hatin.herokuapp.com" + dataFromHere.posterURL).responseImage { response in
            switch response.result {
            case .success:
                if let image = response.result.value {
                    self.imagePosterMovie.image = image
                    print("image downloaded: \(image)")
                }
            case .failure:
                return
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
