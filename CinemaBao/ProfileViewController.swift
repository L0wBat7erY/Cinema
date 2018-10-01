//
//  ProfileViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/28/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var listFavoriteMovie = [Movie]()
  
  @IBOutlet weak var viewProfileDefault: UIImageView!
  @IBOutlet weak var iconEmail: UIImageView!
  @IBOutlet weak var iconUserName: UIImageView!
  @IBOutlet weak var lblEmail: UILabel!
  @IBOutlet weak var lblUserName: UILabel!
  @IBOutlet weak var collectionViewMovie: UICollectionView!
  @IBAction func logOutProfile(_ sender: Any) {
    
    let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Không", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Có", style: .destructive, handler: { action in
      self.performSegue(withIdentifier: "logOutGotoSignInVC", sender: self)
      self.removeEverythingUserDefault()
      
    }))
    
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func returnListMovieVC(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func resetPasswordBtn(_ sender: Any) {
    self.performSegue(withIdentifier: "gotoResetPasswordVC", sender: self)
  }
  
  @IBAction func changeNameBtn(_ sender: Any) {
    let alert = UIAlertController(title: "Name", message: "Bạn muốn đổi Username?", preferredStyle: .alert)
    let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let yesAction = UIAlertAction(title: "OK", style: .default, handler: { action in
      let txtField = alert.textFields![0]
      print(txtField.text!)
      
      //            Alamofire.request("https://cinema-hatin.herokuapp.com/api/user/edit")
      //            print("\(SignInViewController.userDefault.string(forKey: "token"))")
      
    })
    alert.addTextField(configurationHandler: {(textField: UITextField) in
      textField.keyboardAppearance = .dark
      textField.keyboardType = .default
      textField.autocorrectionType = .default
      textField.text = SignInViewController.userDefault.string(forKey: "userName")
      textField.clearButtonMode = .whileEditing
    })
    
    
    
    alert.addAction(noAction)
    alert.addAction(yesAction)
    present(alert, animated: true)
  }
  
  
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
    default:
      break
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return listFavoriteMovie.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 166, height: 100)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MovieInUserDetailCell
    cell.setDatainCell(listFavoriteMovie[indexPath.row])
    return cell
  }
  
  func removeEverythingUserDefault() {
    SignInViewController.userDefault.removeObject(forKey: "token")
    SignInViewController.userDefault.removeObject(forKey: "userNameID")
    SignInViewController.userDefault.removeObject(forKey: "userName")
    SignInViewController.userDefault.removeObject(forKey: "email")
    SignInViewController.userDefault.removeObject(forKey: "password")
  }
  
  
  
}


