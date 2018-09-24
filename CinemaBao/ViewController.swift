//
//  ViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var labelListMovie: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var danhsachphim =  [Movie]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return danhsachphim.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
//        cell.tenPhim.text = self.danhsachphim[indexPath.row].name
//        cell.idPhim.text = self.danhsachphim[indexPath.row]._id
        cell.setDatainCell(danhsachphim[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func fetchData() {
        if let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema") {
            Alamofire.request(url)
                .responseJSON { (reponse) in
                    guard let listFilm = try? JSONDecoder().decode(FilmList.self, from: reponse.data!) else {
                        //lay du lieu khong thanh cong
                        print("Error")
                        return
                    }
                    
                    self.danhsachphim = listFilm.films
                    print(self.danhsachphim[0]._id)
                    
                    self.tableView.reloadData()
                    
            }
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


