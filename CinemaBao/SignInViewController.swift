//
//  SignInViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Toaster
import Alamofire

class SignInViewController: UIViewController {
  
  static var userDefault: UserDefaults = UserDefaults.standard
  
  @IBOutlet weak var iconPassWord: UIImageView!
  @IBOutlet weak var iconEmailLogin: UIImageView!
  @IBOutlet weak var txtEmailSignIn: UITextField!
  @IBOutlet weak var txtPasswordSignIN: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    iconPassWord.image = UIImage.fontAwesomeIcon(name: .lock, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    iconEmailLogin.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    switch segue.identifier {
    case "SignInSuccess":
      print("SignInSuccess")
    case "gotoSignUpVC":
      print("gotoSignUpVC")
    case "forgetPassword":
      print("forgetPassword")
    case "gobackListMovienoSignIn":
      print("gobackListMovienoSignIn")
    default:
      break
    }
  }

}

extension SignInViewController{
  
  // 'Đăng nhập' Button
  @IBAction func loginSuccessListMovie(_ sender: Any) {
    
    if txtEmailSignIn.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
      let toast = Toast(text: "Vui lòng nhập Email")
      toast.show()
      return
    }
    
    if isValidEmail(testStr: txtEmailSignIn.text!) == false {
      let toast = Toast(text: "Email không hợp lệ")
      toast.show()
      return
    }
    
    if txtPasswordSignIN.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
      let toast = Toast(text: "Vui lòng nhập Password")
      toast.show()
      return
    }
    
    let url = URL(string: "https://cinema-hatin.herokuapp.com/api/auth/signin")
    let user: [String: String] = ["email" : txtEmailSignIn.text!, "password": txtPasswordSignIN.text!]
    Alamofire.request(url!, method: .post, parameters: user, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {
      (response) in
      switch response.result {
        
      case .success:
        guard let infoSignIn = try? JSONDecoder().decode(GetToken.self, from: response.data!) else {
          print("Error")
          return
        }
        SignInViewController.userDefault.set(infoSignIn.token, forKey: "token")
        SignInViewController.userDefault.set(infoSignIn.user._id, forKey: "userNameID")
        SignInViewController.userDefault.set(infoSignIn.user.name, forKey: "userName")
        SignInViewController.userDefault.set(infoSignIn.user.email, forKey: "email")
        SignInViewController.userDefault.set(self.txtPasswordSignIN.text, forKey: "password")
        SignInViewController.userDefault.set(infoSignIn.user.avatarURL, forKey: "avatarURL")
        
        if (infoSignIn.status == 200) {
          self.performSegue(withIdentifier: "SignInSuccess", sender: self)
          let toast = Toast(text: "Đăng nhập thành công")
          toast.show()
          print(infoSignIn.token)
        } else {
          let toast = Toast(text: "Lỗi đăng nhập")
          toast.show()
        }
        
      case .failure:
        let toast = Toast(text: "Đăng nhập thất bại")
        toast.show()
      }
    })
  }
  
  //Press display turn off Keyboard
  @IBAction func turnOffBoard(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  // 'Đăng ký' Button
  @IBAction func signupBtn(_ sender: Any) {
    self.performSegue(withIdentifier: "gotoSignUpVC", sender: self)
  }
  
  // 'Quên mật khẩu' Button
  @IBAction func resetPasswordSignIn(_ sender: Any) {
    self.performSegue(withIdentifier: "forgetPassword", sender: self)
  }
  
  // 'Back' Button
  @IBAction func gobackListMovieNoSignIn(_ sender: Any) {
    self.performSegue(withIdentifier: "gobackListMovienoSignIn", sender: nil)
  }
}

extension SignInViewController {
  
  func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }
}
