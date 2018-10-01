//
//  ApiCall.swift
//  CinemaBao
//
//  Created by macOS Sierra on 10/1/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation
import Alamofire

class ApiCall {
    class func getListMovies(url: URL, completion: @escaping (_ listFilm: [Movie]) -> Void) -> Void {

        //Alamofire
        Alamofire.request(url)
            .responseJSON { (reponse) in
                guard let listFilm = try? JSONDecoder().decode(FilmList.self, from: reponse.data!) else {
                    //lay du lieu khong thanh cong
                    print("Error")
                    return
                }
                completion(listFilm.films)
        }
    }
}


