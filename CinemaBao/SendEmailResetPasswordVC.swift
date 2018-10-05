//
//  SendEmailResetPasswordVC.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/30/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire
import Toaster

class SendEmailResetPasswordVC: UIViewController {
  
  var url = "https://cinema-hatin.herokuapp.com/api/auth/reset-password"
  
  @IBOutlet weak var txtEmailinResetPasswordVC: UITextField!
  @IBOutlet weak var iconEmail: UIImageView!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    iconEmail.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case "resetPasswordsuccess":
      print("resetPasswordsuccess")
    case "noResetPassWord":
      print("noResetPassWord")
    default:
      break
    }
  }

}

extension SendEmailResetPasswordVC {
  
  func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
  }
}

extension SendEmailResetPasswordVC {
  
  // Turn off keyboard
  @IBAction func turnOffKeyboard(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  // 'Back' Button
  @IBAction func gobackSignInVC(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // 'Gửi email' Button
  @IBAction func sendEmailBtn(_ sender: Any) {
    if txtEmailinResetPasswordVC.text?.trimmingCharacters(in: .whitespaces).count == 0 {
      let toast = Toast(text: "Vui lòng nhập Email")
      toast.show()
      return
    }
    if isValidEmail(testStr: txtEmailinResetPasswordVC.text!) == false {
      let toast = Toast(text: "Email không hợp lệ")
      toast.show()
      return
    }
    let parameters: [String: String] = ["email": txtEmailinResetPasswordVC.text!]
    Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(response) in
      switch response.result {
      case .success:
        print("Success")
        print(response)
        let status = response.response?.statusCode
        if status == 200 {
          let toast = Toast(text: "Yêu cầu thay đổi mật khẩu thành công.Vui lòng kiểm tra email")
          toast.show()
          self.performSegue(withIdentifier: "resetPasswordsuccess", sender: self)
        } else {
          let toast = Toast(text: "Không tìm thấy tài khoản. Vui lòng kiểm tra lại")
          toast.show()
        }
      case .failure:
        print("Fail")
        let toast = Toast(text: "Lỗi")
        toast.show()
      }
    })
  }

}
