//
//  AddNewMovie.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/25/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import UIKit
import Toaster
import Alamofire
import AlamofireImage

class AddNewMovie: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var addImgMovie: UIImageView!
    @IBOutlet weak var addNameMovie: UITextField!
    @IBOutlet weak var addGenreMovie: UITextField!
    @IBOutlet weak var addReleaseDate: UITextField!
    @IBOutlet weak var addContent: UITextView!
    
//    var imageMovie = "ProfileMovie.png"
    var imagePicker = UIImagePickerController()
    @IBAction func chooseImgBtn(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImgMovie.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
 
    
    @IBAction func addMovieBtn(_ sender: Any) {
        if addNameMovie.text == "" {
            let toast = Toast(text: "Vui lòng nhập Tên phim")
            toast.show()
            return
        }
        
        let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema")
        let parameter = ["name": addNameMovie.text!, "gerne": addGenreMovie.text!, "releaseDate": addReleaseDate.text!, "content": addContent.text! ]
        Alamofire.request(url!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: {(response) in
            switch response.result {
            case .success:
                print("Success")
                let toast = Toast(text: "Đã tạo Phim thành công")
                toast.show()
            case .failure:
                print("Fail")
            }
        })
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        
        addContent.layer.borderColor = color;
        addContent.layer.borderWidth = 1.0;
        addContent.layer.cornerRadius = 5.0;
        
        addImgMovie.image = UIImage(named: "ProfileMovie.png")
//        addImgMovie.image = image
//        self.addImgMovie = UIImage(named: "ProfileMovie.png")
//        addImgMovie.image = image
        
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
