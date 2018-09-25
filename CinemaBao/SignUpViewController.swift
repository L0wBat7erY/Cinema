//
//  SingUpViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Toaster

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtUsernameSignUp: UITextField!
    @IBOutlet weak var txtEmailSignUp: UITextField!
    @IBOutlet weak var txtPasswordSignUP: UITextField!
    @IBOutlet weak var txtConfirmSignUp: UITextField!
    
    
    
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
        
        self.present(signUpVC, animated: true, completion: nil)
        let toast = Toast(text: "Đăng ký thành công")
        toast.show()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
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
