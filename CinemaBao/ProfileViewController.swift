//
//  ProfileViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/28/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var viewProfileDefault: UIImageView!
    @IBAction func logOutProfile(_ sender: Any) {
        
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Không", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Có", style: .destructive, handler: { action in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let logoutSuccess = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(logoutSuccess, animated: true, completion: nil)
            SignInViewController.userDefault.removeObject(forKey: "token")
            SignInViewController.userDefault.removeObject(forKey: "userNameID")
            SignInViewController.userDefault.removeObject(forKey: "userName")
            SignInViewController.userDefault.removeObject(forKey: "email")

        }))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewProfileDefault.image = UIImage(named: "profile.png")
        
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
