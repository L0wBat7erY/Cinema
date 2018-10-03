//
//  EditMovieViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/30/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import HSDatePickerViewController

class EditMovieViewController: UIViewController, HSDatePickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
  

  @IBOutlet weak var genrePK: UIPickerView!
  @IBOutlet weak var txtNameMovie: UITextField!
  @IBOutlet weak var txtGenre: UITextField!
  @IBOutlet weak var txtReleaseDate: UITextField!
  @IBOutlet weak var txtContent: UITextView!
  @IBOutlet weak var imgPosterMovie: UIImageView!
  
  @IBAction func turnOffKeyboardBtn(_ sender: Any) {
    genrePK.isHidden = false
    self.view.endEditing(true)
  }
  
  var dataInEditVC = Movie()
  let dateReleaseVC = HSDatePickerViewController()
  let listGenreMovie = ["Action", "Adventure", "Sci-fi", "Drama", "Cartoon"]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let color = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
    txtContent.layer.borderColor = color;
    txtContent.layer.borderWidth = 1.0;
    txtContent.layer.cornerRadius = 5.0;
    
    dateReleaseVC.delegate = self
    
    txtNameMovie.text = dataInEditVC.name
    txtGenre.text = dataInEditVC.genre
    txtReleaseDate.text = ViewController().convertTimestampToHumanDate(timestamp: dataInEditVC.releaseDate)
    txtContent.text = dataInEditVC.content
    
    Alamofire.request("https://cinema-hatin.herokuapp.com" + dataInEditVC.posterURL).responseImage { response in
      switch response.result {
      case .success:
        if let image = response.result.value {
          self.imgPosterMovie.image = image
          //                    print("image downloaded: \(image)")
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
  
  @IBAction func turnBackDetailnoEdit(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addDatePK(_ sender: Any) {
    present(dateReleaseVC, animated: true, completion: nil)
  }
  @IBAction func addGenreMovie(_ sender: UITextField) {
    
  }
  
  func hsDatePickerPickedDate(_ date: Date!) {
    let formatterDay = DateFormatter()
    formatterDay.dateFormat = "dd/MM/yyyy"
    txtReleaseDate.text = formatterDay.string(from: date)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listGenreMovie.count
  }
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //    self.view.endEditing(true)
    return listGenreMovie[row]
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    txtGenre.text = listGenreMovie[row]
  }
}
