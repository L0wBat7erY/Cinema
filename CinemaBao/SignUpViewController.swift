//
//  SingUpViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Toaster
import FontAwesome_swift
import Alamofire

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtUsernameSignUp: UITextField!
    @IBOutlet weak var txtEmailSignUp: UITextField!
    @IBOutlet weak var txtPasswordSignUP: UITextField!
    @IBOutlet weak var txtConfirmSignUp: UITextField!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var iconUserSignUp: UIImageView!
    @IBOutlet weak var iconEmailSignUp: UIImageView!
    @IBOutlet weak var iconPasswordSignUp: UIImageView!
    @IBOutlet weak var iconConfirmSignUp: UIImageView!
    
    
    
    @IBAction func signInBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signinVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        
       self.present(signinVC, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//        txtEmailSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines).count
        
        if txtUsernameSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let toast = Toast(text: "Vui lòng nhập Username")
            toast.show()
            
            return
        }
        if txtEmailSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let toast = Toast(text: "Vui lòng nhập email")
            toast.show()
            
            return
        }
        if txtPasswordSignUP.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let toast = Toast(text: "Vui lòng nhập password")
            toast.show()
            
            return
        }
        if txtConfirmSignUp.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let toast = Toast(text: "Vui lòng nhập lại password")
            toast.show()
            return
        }
        if txtConfirmSignUp.text != txtPasswordSignUP.text {
            let toast = Toast(text: "Password không khớp")
            toast.show()
            return
        }
        
//        var userInfoTemp = UserInfo()
        
        let url = URL(string: "https://cinema-hatin.herokuapp.com/api/auth/signup")
        let user: [String: String] = ["email" : txtEmailSignUp.text!, "name": txtUsernameSignUp.text!, "password": txtPasswordSignUP.text!]
        Alamofire.request(url!, method: .post, parameters: user, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                self.present(signUpVC, animated: true, completion: nil)
                let toast = Toast(text: "Đăng ký thành công")
                toast.show()
            case .failure:
                let toast = Toast(text: "Đăng ký thất bại")
                toast.show()
               
            }
            guard let dulieu = try? JSONDecoder().decode(UserInfo.self, from: response.data!) else {
                
                return
            }
        }
    )}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        iconUserSignUp.image = UIImage.fontAwesomeIcon(name: .users, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        
        iconEmailSignUp.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        
        iconPasswordSignUp.image = UIImage.fontAwesomeIcon(name: .lock, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))
        
        iconConfirmSignUp.image = UIImage.fontAwesomeIcon(name: .key, style: .solid, textColor: .white, size: CGSize(width: 30, height: 30))

//        self.lblCinemaSignUp.layer.borderColor = UIColor.white.cgColor
        lblSignUp.layer.borderColor = UIColor.green.cgColor
        
        
        
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

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}


