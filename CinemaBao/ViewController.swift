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
  let token = SignInViewController.userDefault.string(forKey: "token")
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var addNewImg: UIButton!
  @IBOutlet weak var imgBtnProfile: UIButton!
  @IBOutlet weak var labelListMovie: UILabel!
  @IBOutlet weak var tableView: UITableView!

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(updateListMovie(_:)), for: UIControlEvents.valueChanged)
    refreshControl.tintColor = UIColor.blue
    return refreshControl
  }()
  
  @objc func updateListMovie (_ refreshControl: UIRefreshControl) {
    fetchData()
    self.tableView.reloadData()
    refreshControl.endRefreshing()
  }
  
  // MARK: - View Did Load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    searchBar.delegate = self
    
    addNewImg.layer.cornerRadius = 30
    imgBtnProfile.layer.cornerRadius = 30
    
    fetchData()
    tableView.reloadData()
    
    tableView.refreshControl = refreshControl
    
    if token == nil {
      imgBtnProfile.isHidden = true
    }
    else {
      imgBtnProfile.isHidden = false
    }
    
    fetchData()
    tableView.reloadData()
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
      destVC.segueID = "gotoDetailMovie"
    case "gotoDetailUser":
      print("gotoDetailUser")
      let destVC: ProfileViewController = segue.destination as! ProfileViewController
      
      for phim in danhsachphim {
        if phim.user._id == idUserDefault {
          destVC.listFavoriteMovie.append(phim)
        }
      }
    default:
      break
    }
    
  }
  
  // MARK: - View will Appear
  override func viewWillAppear(_ animated: Bool) {
    fetchData()
    tableView.reloadData()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

///////////////////////////End Class/////////////////////////////////////////

// Action in View Controller
extension ViewController {
  
  // MARK: - Press Back button
  @IBAction func gotoProfile(_ sender: Any) {
    self.performSegue(withIdentifier: "gotoDetailUser", sender: self)
  }
  
  // MARK: - Press 'Tạo phim' button go to View 'Danh sách phim'
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
  
  // MARK: - Button turn off keyboard display when typing
  @IBAction func turnOffKeyboard(_ sender: Any) {
    self.view.endEditing(true)
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

// MARK: - Define Search bar Delegate
extension ViewController: UISearchBarDelegate {
  
}

// Function implement in Class View Controller
extension ViewController {
  
  // MARK: - Search Bar
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == "" || searchBar.text == nil {
      searchIsTrue = false
      tableView.reloadData()
    }
    else {
      searchIsTrue = true
      for _ in danhsachphim {
        listMovietoSearch = danhsachphim.filter({ (phim) -> Bool in
          return phim.name.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)) || phim.genre.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil))  || phim.content.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil)) || convertTimestampToHumanDate(timestamp: phim.releaseDate).folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil).contains(searchText.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: nil))
        })
      }
      tableView.reloadData()
    }
  }
  
  // Call API and get the List Movie (Assign 'danhsachphim' with 'List Movie returned') and reload Data TableView
  // MARK: - Get data from API
  func fetchData() {
    if let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema") {
      ApiCall.getListMovies(url: url) { (movies) in
        self.danhsachphim = movies
        self.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Convert Timestamp to Human Date
  func convertTimestampToHumanDate(timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let formatterDate = DateFormatter()
    formatterDate.dateFormat = "dd/MM/yyyy"
    let strDate = formatterDate.string(from: date)
    return strDate
  }
}
