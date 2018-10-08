//
//  ProfileViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/28/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class ProfileViewController: UIViewController {
  
  var listFavoriteMovie = [Movie]()
  var selectMovie = Movie()
  var username = ""
  var imagePicker = UIImagePickerController()
  var avatar = SignInViewController.userDefault.string(forKey: "avatarURL")
  var avatar1 = ""
  lazy var str = randomString(length: 5)
  let url = URL(string: "https://cinema-hatin.herokuapp.com/api/auth/user")
  var token = SignInViewController.userDefault.string(forKey: "token")
  let parameters: [String: String] = ["token": SignInViewController.userDefault.string(forKey: "token")!]
  var email = SignInViewController.userDefault.string(forKey: "userName")
  var poster = UIImage()
  
  
  @IBOutlet weak var viewProfileDefault: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var iconEmail: UIImageView!
  @IBOutlet weak var iconUserName: UIImageView!
  @IBOutlet weak var lblEmail: UILabel!
  @IBOutlet weak var lblUserName: UILabel!
  @IBOutlet weak var collectionViewMovie: UICollectionView!
  
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(updateProfile(_:)), for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.white
    return refreshControl
  }()
  
  
  // Refresh Control
  @objc func updateProfile (_ refreshControl: UIRefreshControl) {
    Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(response) in
      switch response.result {
      case .success:
        guard let info = try? JSONDecoder().decode(UserInfo.self, from: response.data!) else {
          print("Error")
          return
        }
        print(response)
        SignInViewController.userDefault.set(info.name, forKey: "userName")
        self.lblUserName.text = info.name
        SignInViewController.userDefault.set(info.avatarURL, forKey: "avatarURL")
        Alamofire.request("https://cinema-hatin.herokuapp.com" + info.avatarURL).responseImage(completionHandler: { (response) in
          print(response)
          
          switch response.result {
          case .success:
            if let image = response.result.value {
              DispatchQueue.main.async {
                self.viewProfileDefault.image = image
              }
            }
          case .failure:
            print("Error")
            return
          }
        })
      case .failure:
        print("Error")
      }
    })
    
    
    fetchData()
    collectionViewMovie.reloadData()
    refreshControl.endRefreshing()
  }
  

  // View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    iconUserName.image = UIImage.fontAwesomeIcon(name: .edit, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    iconEmail.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    if SignInViewController.userDefault.string(forKey: "email") == nil {
      lblEmail.text = "UserName@mail.com"
    }
    else {
      lblEmail.text = SignInViewController.userDefault.string(forKey: "email")
    }
    if SignInViewController.userDefault.string(forKey: "userName") == nil {
      lblUserName.text = "Name"
    }
    else {
      lblUserName.text = SignInViewController.userDefault.string(forKey: "userName")
    }
    
    viewProfileDefault.image = UIImage(named: "profile.png")
    
    collectionViewMovie.delegate = self
    collectionViewMovie.dataSource = self
    collectionViewMovie.reloadData()

    scrollView.contentSize.height = 580
    
    fetchData()
    collectionViewMovie.reloadData()
    
    scrollView.refreshControl = refreshControl
    
    if username != SignInViewController.userDefault.string(forKey: "userName") , username != "" {
      lblUserName.text = username
    }
    
    let urlAvatar = URL(string: "https://cinema-hatin.herokuapp.com" + avatar!)
    viewProfileDefault.sd_setImage(with: urlAvatar, placeholderImage: UIImage(named: "ProfileMovie"))
    
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "logOutGotoSignInVC":
      print("logOutGotoSignInVC")
    case "gotoResetPasswordVC":
      print("gotoResetPasswordVC")
      print(token!)
    case "goDetailMovieinProfile":
      print("goDetailMovieinProfile")
      let destVC: FilmInfo = segue.destination as! FilmInfo
      destVC.dataFromHere = selectMovie
    case "createMovieinUserVC":
      print("createMovieinUserVC")
    case "goBackListMovie":
      print("goBackListMovie")
    default:
      break
    }
  }
  
}


///////////////////////////End Class/////////////////////////////////////////


extension ProfileViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return listFavoriteMovie.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieInUserDetailCell
    cell.setDatainCell(listFavoriteMovie[indexPath.row])
    return cell
  }
}

extension ProfileViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 166, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    selectMovie = listFavoriteMovie[indexPath.item]
    self.performSegue(withIdentifier: "goDetailMovieinProfile", sender: self)
  }
}

// Image picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      viewProfileDefault.image = pickedImage
      poster = pickedImage
      
      let headers: HTTPHeaders = ["x-access-token": token!]
      let urlChangeAvatar = URL(string: "https://cinema-hatin.herokuapp.com/api/user/change-avatar")
      Alamofire.upload(multipartFormData: { (multipart) in
        if let data = UIImageJPEGRepresentation(self.poster, 1.0) {
          multipart.append(data, withName: "file", fileName: self.str + ".jpeg", mimeType: "image/jpeg")
        }
        
      }, usingThreshold: UInt64.init(), to: urlChangeAvatar!, method: .post, headers: headers) { (result) in
        switch result {
        case .success(let upload, _, _) :
          upload.responseJSON { response in
            debugPrint(response)
          }
          upload.uploadProgress{ print("--->", $0.fractionCompleted)}
          print("Success")
          
          let toast = Toast(text: "Đã thay đổi ảnh thành công")
          toast.show()
          self.avatar1 = "/images/" + self.str + ".jpeg"
          SignInViewController.userDefault.set(self.avatar1, forKey: "avatarURL")
        case .failure(let encodingError):
          print(encodingError)
          print("Fail")
        }
      }
      
    }
    
    dismiss(animated: true, completion: nil)
  }
}


extension ProfileViewController {
  
  // create a random string
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
  
  // Delete userDefault
  func removeEverythingUserDefault() {
    SignInViewController.userDefault.removeObject(forKey: "token")
    SignInViewController.userDefault.removeObject(forKey: "userNameID")
    SignInViewController.userDefault.removeObject(forKey: "userName")
    SignInViewController.userDefault.removeObject(forKey: "email")
    SignInViewController.userDefault.removeObject(forKey: "password")
  }
  
  // Call API get data movie
  func fetchData() {
    let idUserDefault = SignInViewController.userDefault.string(forKey: "userNameID")
    if let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema") {
      ApiCall.getListMovies(url: url) { (movies) in
        self.listFavoriteMovie = movies.filter({ (phim) -> Bool in
          return phim.creatorId == idUserDefault
        })
        print(self.listFavoriteMovie)
        self.collectionViewMovie.reloadData()
      }
    }
  }
}


extension ProfileViewController: UINavigationControllerDelegate {
  
  // 'Back' Button
  @IBAction func returnListMovieVC(_ sender: Any) {
    performSegue(withIdentifier: "goBackListMovie", sender: self)
  }
  
  // 'Đổi mật khẩu' Button
  @IBAction func resetPasswordBtn(_ sender: Any) {
    self.performSegue(withIdentifier: "gotoResetPasswordVC", sender: self)
  }
  
  // 'Tạo phim' Button
  @IBAction func createMovieInProfileVC(_ sender: Any) {
    self.performSegue(withIdentifier: "createMovieinUserVC", sender: self)
  }
  
  // 'Chọn ảnh' Button
  @IBAction func addImageAvatar(_ sender: Any) {
    
    if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
      print("Button capture")
      
      imagePicker.delegate = self
      imagePicker.sourceType = .savedPhotosAlbum
      imagePicker.allowsEditing = false
      
      self.present(imagePicker, animated: true, completion: nil)
      
    }
  }
  
  // Edit name Button
  @IBAction func changeNameBtn(_ sender: Any) {
    
    let alert = UIAlertController(title: "Name", message: "Bạn muốn đổi Username?", preferredStyle: .alert)
    let noAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    let yesAction = UIAlertAction(title: "OK", style: .default, handler: { action in
      let txtField = alert.textFields![0]
      
      print(txtField.text!)
      
      let url = "https://cinema-hatin.herokuapp.com/api/user/edit"
      let parameter: [String: String] = ["name": txtField.text!]
      let token = SignInViewController.userDefault.string(forKey: "token")
      let headers: HTTPHeaders = ["x-access-token": token!]
      Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) in
        switch response.result {
          
        case .success:
          guard let info = try? JSONDecoder().decode(ListInfoSignUp.self, from: response.data!) else {
            print("Error")
            return
          }
          if info.status == 200 {
            let toast = Toast(text: "Đổi tên thành công")
            self.lblUserName.text = txtField.text
            toast.show()
            SignInViewController.userDefault.set(txtField.text, forKey: "userName")
            
          } else {
            let toast = Toast(text: info.message)
            toast.show()
          }
          
        case .failure:
          print("Error")
        }
      })
      
    })
    alert.addTextField(configurationHandler: {(textField: UITextField) in
      textField.keyboardAppearance = .dark
      textField.keyboardType = .default
      textField.autocorrectionType = .default
      textField.text = self.email
      textField.clearButtonMode = .whileEditing
    })
    
    alert.addAction(noAction)
    alert.addAction(yesAction)
    present(alert, animated: true)
    
  }
  
  // 'Đăng xuất' Button
  @IBAction func logOutProfile(_ sender: Any) {
    
    let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Không", style: .destructive, handler: nil))
    alert.addAction(UIAlertAction(title: "Có", style: .default, handler: { action in
      self.performSegue(withIdentifier: "logOutGotoSignInVC", sender: self)
      self.removeEverythingUserDefault()
      
    }))
    
    present(alert, animated: true, completion: nil)
  }
}
