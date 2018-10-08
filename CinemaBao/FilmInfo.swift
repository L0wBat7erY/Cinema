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
import Toaster
import SDWebImage

class FilmInfo: UIViewController {
  
  @IBOutlet weak var lblNameMovie: UILabel!
  @IBOutlet weak var lblGenre: UILabel!
  @IBOutlet weak var lblReleaseDate: UILabel!
  @IBOutlet weak var imagePosterMovie: UIImageView!
  @IBOutlet weak var lblEdit: UIButton!
  @IBOutlet weak var lblDelete: UIButton!
  @IBOutlet weak var createDate: UILabel!
  @IBOutlet weak var creator: UILabel!
  @IBOutlet weak var lblContent: UITextView!
  
  var dataFromHere = Movie()
  let idUser = SignInViewController.userDefault.string(forKey: "userNameID")
  var token = SignInViewController.userDefault.string(forKey: "token")
  lazy var headers: HTTPHeaders = ["x-access-token": token!]
  let url = "https://cinema-hatin.herokuapp.com"
  let urlDelete = "/api/cinema/delete"
  var segueID = ""
  
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    lblNameMovie.text = dataFromHere.name
    lblGenre.text = dataFromHere.genre
    lblReleaseDate.text = ViewController().convertTimestampToHumanDate(timestamp: dataFromHere.releaseDate)
    lblContent.text = dataFromHere.content
    createDate.text = ViewController().convertTimestampToHumanDate(timestamp: dataFromHere.createdDate/1000)
    creator.text = dataFromHere.user.name
    
    let urlImage = URL(string: url + dataFromHere.posterURL)
    imagePosterMovie.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "ProfileMovie"))
    
    if dataFromHere.user._id != idUser {
      lblEdit.isHidden = true
      lblDelete.isHidden = true
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "gotoFixDetailMovie":
      print("gotoFixDetailMovie")
      let destVC: AddNewMovie = segue.destination as! AddNewMovie
      destVC.dataInEdit = dataFromHere
      destVC.checkSegue = "gotoFixDetailMovie"
      destVC.releaseDate = lblReleaseDate.text!
      destVC.createDate = createDate.text!
    case "deleteSuccess":
      print("deleteSuccess")
    case "deleteMovieinProfileVC":
      print("deleteMovieinProfileVC")
    default:
      break
    }
  }
}

///////////////////////////End Class///////////////////////////////////////////////

extension FilmInfo {
  
  //MARK: - Convert Timestamp to Human Date
  func convertTimestampToHumanDate(timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatterDate = DateFormatter()
    formatterDate.dateFormat = "dd/MM/yyyy"
    let strDate = formatterDate.string(from: date)
    return strDate
  }
}

extension FilmInfo {
  
  // MARK: - 'Sửa' Button
  @IBAction func editMovieBtn(_ sender: Any) {
    self.performSegue(withIdentifier: "gotoFixDetailMovie", sender: self)
  }
  
  // MARK: - 'Back' Button
  @IBAction func backList(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - 'Xóa' Button
  @IBAction func deleteMovie(_ sender: Any) {
    
    // Alert Notification
    let alert = UIAlertController(title: "Xóa phim", message: "Bạn có thật sự muốn xóa phim không?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Không", style: .destructive, handler: nil))
    alert.addAction(UIAlertAction(title: "Có", style: .default, handler: { action in
      let parameters: [String: String] = ["_id": self.dataFromHere._id]
      let urldelete = URL(string: self.url + self.urlDelete)
      Alamofire.request(urldelete!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers).responseJSON(completionHandler: {(response) in
        switch response.result {
        case .success:
          let toast = Toast(text: "Xóa phim thành công")
          toast.show()
          if self.segueID == "gotoDetailMovie" {
            self.performSegue(withIdentifier: "deleteSuccess", sender: self)
          } else {
            self.performSegue(withIdentifier: "deleteMovieinProfileVC", sender: self)
          }
        case .failure:
          print("Error")
        }
      })
    }))
    
    present(alert, animated: true, completion: nil)
  }
}
