//
//  ViewController.swift
//  CinemaPr
//
//  Created by macOS Sierra on 9/22/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire
import FontAwesome_swift


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var danhSachPhim: UILabel!
    
    
    //var Film: [[String: Any]] = [[String: Any]]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelFont = UILabel()
        labelFont.font = UIFont.fontAwesome(ofSize: 100, style: .brands)
        labelFont.text = String.fontAwesomeIcon(name: .github)
        view.addSubview(labelFont)
        labelFont.frame = CGRect(x:60, y: 60, width: 200, height: 300)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        Alamofire.request("https://cinema-hatin.herokuapp.com/api/cinema").responseJSON { (response) in
            if response.result.value != nil {
                print(response)
            }
            
        }
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



