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
import MobileCoreServices

class ViewController: UIViewController {
    
  
    var danhsachphim =  [Movie]()
    var listMovietoSearch = [Movie]()
    var searchIsTrue = false
    var selectedPhim = Movie()
  var idUserDefault = SignInViewController.userDefault.string(forKey: "userNameID")
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addNewImg: UIButton!
    @IBOutlet weak var imgBtnProfile: UIButton!
    @IBOutlet weak var labelListMovie: UILabel!
    @IBOutlet weak var tableView: UITableView!
  @IBAction func turnOffKeyboard(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(updateListMovie(_:)), for: UIControlEvents.valueChanged)
//    self.tableView.addSubview(self.refreshControl)
    refreshControl.tintColor = UIColor.blue
    return refreshControl
  }()
  
  @objc func updateListMovie (_ refreshControl: UIRefreshControl) {
    fetchData()
    self.tableView.reloadData()
    refreshControl.endRefreshing()
  }
  
    @IBAction func addNewMovieBtn(_ sender: Any) {
        
        if SignInViewController.userDefault.string(forKey: "token") == nil {
            
            let alert = UIAlertController(title: "Đăng nhập", message: "Bạn có muốn đăng nhập để tạo phim?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Hủy", style: .destructive, handler: nil)
            alert.addAction(cancelAction)
            let destroy = UIAlertAction(title: "Đăng nhập", style: .default, handler: {
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
      
      tableView.refreshControl = refreshControl
      
      
//      print("\(SignInViewController.userDefault.string(forKey: "token"))")
        if SignInViewController.userDefault.string(forKey: "token") == nil {
            imgBtnProfile.isHidden = true
        }
        else {
            imgBtnProfile.isHidden = false
        }
        
        fetchData()
        
//        tableView.addPullToRefresh(refreshControl) {
//            self.fetchData()
//        }
//        tableView.endRefreshing()
        
    }
    
    
    func fetchData() {
        //refreah
        
        
        if let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema") {
            ApiCall.getListMovies(url: url) { (movies) in
                self.danhsachphim = movies
                
                self.tableView.reloadData()
                //                    self.activityIndicatorView.
                //                    self.refreshControl.stopAnimation()
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
            let destVC: ProfileViewController = segue.destination as! ProfileViewController
//            destVC.listFavoriteMovie = danhsachphim
            for phim in danhsachphim {
              if phim.user._id == idUserDefault {
                destVC.listFavoriteMovie.append(phim)
              }
          }
        default:
            break
        }
        
    }
  
  override func viewWillAppear(_ animated: Bool) {
    fetchData()
    tableView.reloadData()
  }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UITableViewDataSource {
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
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPhim = danhsachphim[indexPath.row]
        self.performSegue(withIdentifier: "gotoDetailMovie", sender: self)
    }
}

extension ViewController: UISearchBarDelegate {
    
}
