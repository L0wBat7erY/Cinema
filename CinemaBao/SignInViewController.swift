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
        
        
        
        self.present(loginSuccessVC, animated: true, completion: nil)
        
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
