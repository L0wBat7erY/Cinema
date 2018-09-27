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

    @IBOutlet weak var iconPassWord: UIImageView!
    @IBOutlet weak var iconEmailLogin: UIImageView!
    @IBOutlet weak var txtEmailSignIn: UITextField!
    @IBOutlet weak var txtPasswordSignIN: UITextField!
    
//    let token = UserDefaults.standard
    
    
    @IBAction func loginSuccessListMovie(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginSuccessVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        if txtEmailSignIn.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let toast = Toast(text: "Vui lòng nhập Email")
            toast.show()
            
            return
        }
        if txtPasswordSignIN.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            let toast = Toast(text: "Vui lòng nhập Password")
            toast.show()
            
            return
        }
        
        
//        var usrSignIn = GetToken()
        
        let userDefault: UserDefaults = UserDefaults.init()
        let tokenIsGetted: String = ""
        
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
                userDefault.set(infoSignIn.token, forKey: tokenIsGetted)
                if (infoSignIn.status == 200) {
                    self.present(loginSuccessVC, animated: true, completion: nil)
//                    let toast = Toast(text: "Đăng nhập thành công")
//                    toast.show()
                }
                if (infoSignIn.status == 404) {
//                    self.present(loginSuccessVC, animated: true, completion: nil)
                    let toast = Toast(text: infoSignIn.errorMessage)
                    toast.show()
                }
                
            case .failure:
                let toast = Toast(text: "Đăng nhập thất bại")
                toast.show()
            }
        })
        
//        self.present(loginSuccessVC, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func signupBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signupVC, animated: true, completion: nil)
    }

    @IBAction func resetPasswordSignIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let resetPasswordVC = storyboard.instantiateViewController(withIdentifier: "ResetPassWord")
        self.present(resetPasswordVC, animated: true, completion: nil)
    }
    
    
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
