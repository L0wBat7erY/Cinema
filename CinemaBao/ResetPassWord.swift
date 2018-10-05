//
//  ResetPassWord.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/25/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Toaster
import Alamofire

class ResetPassWord: UIViewController {
  
  var token = SignInViewController.userDefault.string(forKey: "token")
  lazy var headers: HTTPHeaders = ["x-access-token": token!]
  var url = "https://cinema-hatin.herokuapp.com/api/user/change-password"
  
  @IBOutlet weak var oldPassword: UITextField!
  @IBOutlet weak var newPassword: UITextField!
  @IBOutlet weak var confirmNewPassword: UITextField!
  
    @IBAction func returnUserVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  @IBAction func turnOffKeyboard(_ sender: Any) {
    self.view.endEditing(true)
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  @IBAction func confirmIsChane(_ sender: Any) {
    if oldPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
      let toast = Toast(text: "Vui lòng nhập mật khẩu cũ")
      toast.show()
      return
    }
    if newPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
      let toast = Toast(text: "Vui lòng mật khẩu mới")
      toast.show()
      return
    }
    if confirmNewPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
      let toast = Toast(text: "Vui lòng nhập lại mật khẩu mới")
      toast.show()
      return
    }
    if newPassword.text != confirmNewPassword.text {
      let toast = Toast(text: "Mật khẩu không khớp")
      toast.show()
      return
    }
    if oldPassword.text != SignInViewController.userDefault.string(forKey: "password") {
      let toast = Toast(text: "Mật khẩu cũ không đúng")
      toast.show()
      return
    }
    if newPassword.text == oldPassword.text {
      let toast = Toast(text: "Mật khẩu cũ và mật khẩu mới giống nhau")
      toast.show()
      return
    }
    
    let parameters: [String: Any] = ["oldPassword": oldPassword.text!, "newPassword": newPassword.text!]
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) in
      switch response.result {
      case .success:
        print("Success")
        let status = response.response?.statusCode
        if status == 200 {
          print(SignInViewController.userDefault.string(forKey: "token")!)
          let toast = Toast(text: "Đổi mật khẩu thành công")
          toast.show()
          self.performSegue(withIdentifier: "changePasswordSuccess", sender: self)
          SignInViewController.userDefault.set(self.newPassword.text, forKey: "password")
        } else {
          let toast = Toast(text: "Lỗi")
          toast.show()
        }
        
      case .failure:
        print("Fail")
      }
    })
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "changePasswordSuccess":
      print("changePasswordSuccess")
    default:
      break
    }
  }

}
