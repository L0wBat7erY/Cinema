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
    
    
    @IBOutlet weak var labelListMovie: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewMovieBtn(_ sender: Any) {
        
        if SignInViewController.userDefault.string(forKey: "token") == nil {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let gotoSignInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//            self.present(gotoSignInVC, animated: true, completion: nil)
            
//            let alert = UIAlertController(title: "Đăng nhập", message: "Bạn có muốn đăng nhập để tạo phim?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Không", style: .default, handler: nil))
//            alert.addAction(UIAlertAction(title: "Có", style: .default , handler: { action in
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let gotoSignInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//                self.present(gotoSignInVC, animated: true, completion: nil)
//            }))
            
//            present(alert, animated: true, completion: nil)
        
        
            let alert = UIAlertController(title: "Đăng nhập", message: "Bạn có muốn đăng nhập để tạo phim?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Không", style: .default, handler: nil)
            alert.addAction(cancelAction)
            let destroy = UIAlertAction(title: "Có", style: .default, handler: {
                action in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let gotoSignInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
                self.present(gotoSignInVC, animated: true, completion: nil)
            })
            alert.addAction(destroy)
            self.present(alert, animated: true)
        
        
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let addNewMovieVC = storyboard.instantiateViewController(withIdentifier: "AddNewMovie")
            self.present(addNewMovieVC, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func gotoProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let goToProfileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(goToProfileVC, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var addNewImg: UIButton!
    @IBOutlet weak var imgBtnProfile: UIButton!
    
    
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
//        cell.tenPhim.text = self.danhsachphim[indexPath.row].name
//        cell.idPhim.text = self.danhsachphim[indexPath.row]._id
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
    
    
    
//    let btn = UIButton(type: .custom)
//    btn.frame = CGRect(x: 285, y: 485, width: 100, height: 100)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        addNewImg.layer.cornerRadius = 30
        imgBtnProfile.layer.cornerRadius = 30

        
//        addNewMovieBtn.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
//        addNewMovieBtn.setTitle(String.fontAwesomeIcon(name: .add), for: .plus)
        
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
    
    func getImage(_: [Movie]) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC: FilmInfo = segue.destination as! FilmInfo
        destVC.dataFromHere = selectedPhim
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


