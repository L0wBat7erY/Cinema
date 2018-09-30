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

    @IBAction func editMovieBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "editMovie", sender: self)
    }
    
    
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
        lblReleaseDate.text = ViewController().convertTimestampToHumanDate(timestamp: dataFromHere.releaseDate)
        lblContent.text = dataFromHere.content
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editMovie":
            print("editMovie")
            let destVC: EditMovieViewController = segue.destination as! EditMovieViewController
            destVC.dataInEditVC = dataFromHere
        default:
            break
        }
    }
    
}
