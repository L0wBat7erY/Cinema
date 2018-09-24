//
//  SignInViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import FontAwesome_swift

class SignInViewController: UIViewController {

    @IBOutlet weak var iconPassWord: UIImageView!
    @IBOutlet weak var iconEmailLogin: UIImageView!
    
    @IBAction func loginSuccessListMovie(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginSuccessVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
        self.present(loginSuccessVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signupBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
        self.present(signupVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconPassWord.image = UIImage.fontAwesomeIcon(name: .lock, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
        
        iconEmailLogin.image = UIImage.fontAwesomeIcon(name: .envelope, style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))

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
