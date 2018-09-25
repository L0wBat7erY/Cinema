//
//  ViewController.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import PullToRefresh

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var labelListMovie: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var number = 0
    
    var danhsachphim =  [Movie]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return danhsachphim.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
//        cell.tenPhim.text = self.danhsachphim[indexPath.row].name
//        cell.idPhim.text = self.danhsachphim[indexPath.row]._id
        cell.setDatainCell(danhsachphim[indexPath.row])
        if danhsachphim.count > 0 {
            let eachImage = danhsachphim[indexPath.row]
            if let imageURL = eachImage.posterURL as? String {
                Alamofire.request("https://cinema-hatin.herokuapp.com" + imageURL).responseImage(completionHandler: { (response) in
                    print(response)
                    if let image = response.result.value {
                        DispatchQueue.main.async {
                            cell.profileMovie?.image = image
                        }
                    }
                })
            }
        }
    
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
        
//        self.tableView.refreshControl = refreshControl
        
//        self.tableView.refreshControl = refreshControl
        
//        self.refreshControl.addTarget(self, action: #selector(updateData(:_<#Any#><#Any#>)), for: .valueChanged)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc private func updateData(_ sender: Any) {
        fetchData()
        self.refreshControl.endRefreshing()
    }

    
    func fetchData() {
        //refreah
        
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
                    
                    //
                   
                    self.tableView.refreshControl = self.refreshControl
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
            }
        }
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


