//
//  SendEmailResetPasswordVC.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/30/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit

class SendEmailResetPasswordVC: UIViewController {

    @IBAction func gobackSignInVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
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

}
