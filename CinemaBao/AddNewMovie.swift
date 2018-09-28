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
import HSDatePickerViewController

class AddNewMovie: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HSDatePickerViewControllerDelegate, UITextFieldDelegate {
    

    

    @IBAction func turnBackListMovie(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var addImgMovie: UIImageView!
    @IBOutlet weak var addNameMovie: UITextField!
    @IBOutlet weak var addGenreMovie: UITextField!
    @IBOutlet weak var addReleaseDate: UITextField!
    @IBOutlet weak var addContent: UITextView!
    
    
    
    
//    var imageMovie = "ProfileMovie.png"
    var imagePicker = UIImagePickerController()
    var poster = UIImage()
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
            poster = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    var bienDate = Date()
    
    func hsDatePickerPickedDate(_ date: Date!) {
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "dd/MM/yyyy"
        addReleaseDate.text = formatterDay.string(from: date)
//        print(addReleaseDate.text)
//        bienDate = date
    }
    
    let dateRelease = HSDatePickerViewController()
    
    @IBAction func datePK(_ sender: UITextField) {
        present(dateRelease, animated: true, completion: nil)
    }
    
    
    @IBAction func addMovieBtn(_ sender: Any) {
        if addNameMovie.text == "" {
            let toast = Toast(text: "Vui lòng nhập Tên phim")
            toast.show()
            return
        }

      
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="dd/MM/yyyy"
        let date = dfmatter.date(from: addReleaseDate.text!)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        
        
        
        let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema")
        let parameter: [String: Any] = ["name": addNameMovie.text!, "gerne": addGenreMovie.text!, "releaseDate": dateSt, "content": addContent.text! ]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameter {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = UIImageJPEGRepresentation(self.poster, 1.0) {
                multipartFormData.append(data, withName: "file", fileName: "imageBao.jpeg", mimeType: "image/jpeg")
            }
        }, usingThreshold: UInt64.init(), to: url!, method: .post, headers: nil) { (result) in
            switch result {
            case .success(let upload, _, _) :
                upload.responseJSON { response in
                    debugPrint(response)
                }
                upload.uploadProgress{ print("--->", $0.fractionCompleted)}
                print("Success")
                let toast = Toast(text: "Đã tạo phim thành công")
                toast.show()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let turnBackListMovieVC = storyboard.instantiateViewController(withIdentifier: "ViewController")
                self.present(turnBackListMovieVC, animated: true, completion: nil)
            case .failure(let encodingError):
                print(encodingError)
                print("Fail")
            }
        }
    }
    
    

    
    
    
    
    

    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        
        addContent.layer.borderColor = color;
        addContent.layer.borderWidth = 1.0;
        addContent.layer.cornerRadius = 5.0;
        
        dateRelease.delegate = self
        
        
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
