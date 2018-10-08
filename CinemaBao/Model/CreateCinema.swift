//
//  CreateCinema.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/27/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation

struct CreateCinema: Codable {
    var cinema: DataCinemaCreatedReturn = DataCinemaCreatedReturn()
    
    enum CodingKeys: String, CodingKey {
        case cinema
    }
}

extension CreateCinema {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cinema = (try values.decodeIfPresent(DataCinemaCreatedReturn.self, forKey: .cinema)) ?? DataCinemaCreatedReturn()
    }
}
