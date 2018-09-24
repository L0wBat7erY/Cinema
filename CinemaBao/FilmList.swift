//
//  ClassKeyJson.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation


struct FilmList: Codable {
    var films = [Movie]()
    
    enum CodingKeys: String, CodingKey {
        case films
    }
    
}

extension FilmList {
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        films = (try values.decodeIfPresent([Movie].self, forKey: .films)) ?? [Movie]()
    }
}
