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
import MobileCoreServices

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addNewImg: UIButton!
    @IBOutlet weak var imgBtnProfile: UIButton!
    @IBOutlet weak var labelListMovie: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewMovieBtn(_ sender: Any) {
        
        if SignInViewController.userDefault.string(forKey: "token") == nil {
            
            
            let alert = UIAlertController(title: "Đăng nhập", message: "Bạn có muốn đăng nhập để tạo phim?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Không", style: .default, handler: nil)
            alert.addAction(cancelAction)
            let destroy = UIAlertAction(title: "Có", style: .default, handler: {
                action in
                self.performSegue(withIdentifier: "gotoAddMovieVCnoSignIn", sender: self)
            })
            alert.addAction(destroy)
            self.present(alert, animated: true)
        }
        else {
            self.performSegue(withIdentifier: "gotoAddMovieVCSignIn", sender: self)
        }
        
        
    }
    
    @IBAction func gotoProfile(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoDetailUser", sender: self)
    }

    
    private let refreshControl = UIRefreshControl()
    private var number = 0
    
    var danhsachphim =  [Movie]()
    var listMovietoSearch = [Movie]()
    var searchIsTrue = false
    var selectedPhim = Movie()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" || searchBar.text == nil {
            searchIsTrue = false
            tableView.reloadData()
        }
        else {
            searchIsTrue = true
            for phim in danhsachphim {
                listMovietoSearch = danhsachphim.filter({ (phim) -> Bool in
                    return phim.name.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)) || phim.genre.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil))  || phim.content.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)) || convertTimestampToHumanDate(timestamp: phim.releaseDate).folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil))
                })
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchIsTrue {
            return listMovietoSearch.count
        }
        else {
            return danhsachphim.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListMovieViewCell
        if searchIsTrue {
            cell.setDatainCell(listMovietoSearch[indexPath.row])
        }
        else {
            cell.setDatainCell(danhsachphim[indexPath.row])
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhim = danhsachphim[indexPath.row]
        self.performSegue(withIdentifier: "gotoDetailMovie", sender: self)
    }
    
    
    func convertTimestampToHumanDate(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "dd/MM/yyyy"
        let strDate = formatterDate.string(from: date)
        return strDate
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        addNewImg.layer.cornerRadius = 30
        imgBtnProfile.layer.cornerRadius = 30
        
        if SignInViewController.userDefault.string(forKey: "token") == nil {
            imgBtnProfile.isHidden = true
        }
        else {
            imgBtnProfile.isHidden = false
        }
        
        fetchData()
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
                    
                    self.tableView.refreshControl = self.refreshControl
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "gotoAddMovieVCSignIn":
            print("gotoAddMovieVCSignIn")
        case "gotoAdMovieVCnoSignIn":
            print("gotoAddMovieVCSignIn")
        case "gotoDetailMovie":
            let destVC: FilmInfo = segue.destination as! FilmInfo
            destVC.dataFromHere = selectedPhim
        case "gotoDetailUser":
            print("gotoDetailUser")
        default:
            break
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


