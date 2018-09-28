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

class AddNewMovie: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, HSDatePickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let manyGerne = ["Action", "Adventure", "Sci-fi", "Drama", "Cartoon"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return manyGerne.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return manyGerne[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addGenreMovie.text = manyGerne[row]
        addGenreMovie.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.addGenreMovie {
            addGenreMovie.isHidden = false
            
        }
    }
    
    
    @IBOutlet weak var pickGerne: UIPickerView!
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        pickGerne.dataSource = self
        pickGerne.delegate = self
    }
    

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
    
 
    
    @IBAction func addMovieBtn(_ sender: Any) {
        if addNameMovie.text == "" {
            let toast = Toast(text: "Vui lòng nhập Tên phim")
            toast.show()
            return
        }
        
        let releaseDate = DateFormatter()
        let dateFormInt = releaseDate.date(from: addReleaseDate.text!)
        let timeInterval = dateFormInt?.timeIntervalSince1970
        let timeFormInt = Int(timeInterval!)
        
        let url = URL(string: "https://cinema-hatin.herokuapp.com/api/cinema")
        let parameter: [String: Any] = ["name": addNameMovie.text!, "gerne": addGenreMovie.text!, "releaseDate": timeFormInt, "content": addContent.text! ]
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
    
    
    
    
    func hsDatePickerPickedDate(_ date: Date!) {
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "dd/MM/yyyy"
        addReleaseDate.text = formatterDay.string(from: date)
    }
    
    let dateRelease = HSDatePickerViewController()

    @IBAction func datePK(_ sender: UITextField) {
        present(dateRelease, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
        
        addContent.layer.borderColor = color;
        addContent.layer.borderWidth = 1.0;
        addContent.layer.cornerRadius = 5.0;
        
        dateRelease.delegate = self
        addGenreMovie.delegate = self
        
        
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
