//
//  AddNewMovie.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/25/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import AlamofireImage
import HSDatePickerViewController

class AddNewMovie: UIViewController  {

  let listGenreMovie = ["Action", "Adventure", "Sci-fi", "Drama", "Cartoon"]
  var imagePicker = UIImagePickerController()
  var poster = UIImage()
  var dataInEdit = Movie()
  var checkSegue = ""
  var releaseDate = ""
  var createDate = ""
  let dateRelease = HSDatePickerViewController()

  
  @IBOutlet weak var genrePK: UIPickerView!
  @IBOutlet weak var addImgMovie: UIImageView!
  @IBOutlet weak var addNameMovie: UITextField!
  @IBOutlet weak var addReleaseDate: UITextField!
  @IBOutlet weak var addMovieBtn: UIButton!
  @IBOutlet weak var addContent: UITextView!
  @IBOutlet weak var addGenreMovie: UITextField!
  @IBOutlet weak var lblThemPhim: UILabel!
  @IBOutlet weak var editMoviebtn: UIButton!
  
  
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let color = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
    
    addContent.layer.borderColor = color;
    addContent.layer.borderWidth = 1.0;
    addContent.layer.cornerRadius = 5.0;
    
    dateRelease.delegate = self
    
    let formatterDay = DateFormatter()
    let dateNow = Date()
    formatterDay.dateFormat = "dd/MM/yyyy"
    addReleaseDate.text = formatterDay.string(from: dateNow)

    genrePK.dataSource = self
    genrePK.delegate = self
    
    if checkSegue == "gotoFixDetailMovie" {
      addMovieBtn.isHidden = true
      lblThemPhim.isHidden = true
      addNameMovie.text = dataInEdit.name
      addContent.text = dataInEdit.content
      addReleaseDate.text = createDate
      editMoviebtn.isHidden = false
      
      let urlposter = URL(string: "https://cinema-hatin.herokuapp.com" + dataInEdit.posterURL)
      addImgMovie.sd_setImage(with: urlposter, placeholderImage: UIImage(named: "ProfileMovie"))
      
    } else {
      editMoviebtn.isHidden = true
      let urlposter = URL(string: "https://cinema-hatin.herokuapp.com" + dataInEdit.posterURL)
      addImgMovie.sd_setImage(with: urlposter, placeholderImage: UIImage(named: "ProfileMovie"))
    }
    
    addGenreMovie.text = "Action"
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
      if self.view.frame.origin.y == 0 {
        self.view.frame.origin.y -= 258
      }
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
      if self.view.frame.origin.y != 0{
        self.view.frame.origin.y += 258
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
    case "createMovieSuccess":
      print("createMovieSuccess")
    case "editSuccessMovie":
      print("editSuccessMovie")
    default:
      break
    }
  }
  
}


///////////////////////////End Class/////////////////////////////////////////

// MARK: - Picker View Delegate
extension AddNewMovie: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    addGenreMovie.text = listGenreMovie[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return listGenreMovie[row]
  }
}

// MARK: - Picker View DataSource
extension AddNewMovie: UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return listGenreMovie.count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
}

// MARK: - Picker Image Picker Delegate
extension AddNewMovie: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      addImgMovie.image = pickedImage
      poster = pickedImage
    }
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - Date Picker Delegate
extension AddNewMovie: HSDatePickerViewControllerDelegate {
  
}

// MARK: - Text Field Delegate
extension AddNewMovie: UITextFieldDelegate {
  
}

// MARK: - Navigation Controller Delegate
extension AddNewMovie: UINavigationControllerDelegate {
  
  @IBAction func turnBackListMovie(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    self.dismiss(animated: true, completion: nil)
  }
}

extension AddNewMovie {
  
  // MARK: - Function create random String
  func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    
    for _ in 0 ..< length {
      let rand = arc4random_uniform(len)
      var nextChar = letters.character(at: Int(rand))
      randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
  }
  
  
  //MARK: - Implement Date Piker
  func hsDatePickerPickedDate(_ date: Date!) {
    let formatterDay = DateFormatter()
    formatterDay.dateFormat = "dd/MM/yyyy"
    addReleaseDate.text = formatterDay.string(from: date)
  }

}

extension AddNewMovie {
  
  // MARK: - 'Chọn ảnh' Button
  @IBAction func chooseImgBtn(_ sender: Any) {
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      print("Button capture")
      
      imagePicker.delegate = self
      imagePicker.sourceType = .savedPhotosAlbum
      imagePicker.allowsEditing = false
      
      self.present(imagePicker, animated: true, completion: nil)
    }
  }
  
  // MARK: - Hidden View Picker
  @IBAction func addGenreMovie(_ sender: UITextField) {
    genrePK.isHidden = false
    self.view.endEditing(true)
  }
  
  // MARK: - Turn off keyboard
  @IBAction func turnOffBtn(_ sender: Any) {
    genrePK.isHidden = true
    self.view.endEditing(true)
  }
  
  // MARK: - Pick a date
  @IBAction func datePK(_ sender: UITextField) {
    present(dateRelease, animated: true, completion: nil)
  }
  
  // MARK: - 'Tạo phim' Button
  @IBAction func addMovieBtn(_ sender: Any) {
    
    if addNameMovie.text == "" {
      let toast = Toast(text: "Vui lòng nhập Tên phim")
      toast.show()
      return
    }
    
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="dd/MM/yyyy"
    let date = dfmatter.date(from: addReleaseDate.text!)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSt:Int = Int(dateStamp)
    
    let str = randomString(length: 5)
    let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema")
    let parameter: [String: Any] = ["name": addNameMovie.text!, "genre": addGenreMovie.text!, "releaseDate": dateSt, "content": addContent.text!, "creatorId": SignInViewController.userDefault.string(forKey: "userNameID")!]
    Alamofire.upload(multipartFormData: { (multipartFormData) in
      for (key, value) in parameter {
        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
      }
      if let data = UIImageJPEGRepresentation(self.poster, 1.0) {
        multipartFormData.append(data, withName: "file", fileName: str + ".jpeg", mimeType: "image/jpeg")
      }
    }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: nil) { (result) in
      switch result {
      case .success(let upload, _, _) :
        upload.responseJSON { response in
          debugPrint(response)
        }
        upload.uploadProgress{ print("--->", $0.fractionCompleted)}
        print("Success")
        let toast = Toast(text: "Đã tạo phim thành công")
        toast.show()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let turnBackListMovieVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
        self.present(turnBackListMovieVC, animated: true, completion: nil)
      case .failure(let encodingError):
        print(encodingError)
        print("Fail")
      }
    }
  }
  
  // MARK: - 'Sửa phim' Button
  @IBAction func editMovieBtn(_ sender: Any) {
    
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="dd/MM/yyyy"
    let date = dfmatter.date(from: addReleaseDate.text!)
    let dateStamp:TimeInterval = date!.timeIntervalSince1970
    let dateSt:Int = Int(dateStamp)
    
    let str = randomString(length: 5)
    let token = SignInViewController.userDefault.string(forKey: "token")
    let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema/edit")
    let parameter: [String: Any] = ["name": addNameMovie.text!, "genre": addGenreMovie.text!, "releaseDate": dateSt, "content": addContent.text!, "creatorId": SignInViewController.userDefault.string(forKey: "userNameID")!, "id": dataInEdit._id]
    let headers: HTTPHeaders = ["x-access-token": token!]
    Alamofire.upload(multipartFormData: { (multipartFormData) in
      for (key, value) in parameter {
        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
      }
      if let data = UIImageJPEGRepresentation(self.poster, 1.0) {
        multipartFormData.append(data, withName: "file", fileName: str + ".jpeg", mimeType: "image/jpeg")
      }
    }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: headers) { (result) in
      switch result {
      case .success(let upload, _, _) :
        
        upload.responseJSON { response in
          debugPrint(response)
          print(response)
        }
        
        upload.uploadProgress{ print("--->", $0.fractionCompleted)}
        print("Success")
        let toast = Toast(text: "Đã sửa phim thành công")
        toast.show()
        self.performSegue(withIdentifier: "editSuccessMovie", sender: self)
      case .failure(let encodingError):
        print(encodingError)
        print("Fail")
      }
    }
  }
}


