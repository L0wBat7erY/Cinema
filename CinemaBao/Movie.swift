//
//  ClassListMovie.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var _id: String = ""
    var name: String = ""
    var creatorId: String = ""
    var genre: String = ""
    var content: String = ""
    var user: UserInfo = UserInfo()
    var posterURL: String = ""
    var releaseDate: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case _id
        case name
        case creatorId
        case genre
        case content
        case user
        case posterURL
        case releaseDate
    }
    
}

extension Movie {
    init(from decoder: Decoder)
    {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            _id = (try values.decodeIfPresent(String.self, forKey: ._id)) ?? ""
            name = (try values.decodeIfPresent(String.self, forKey: .name)) ?? ""
            creatorId = (try values.decodeIfPresent(String.self, forKey: .creatorId)) ?? ""
            genre = (try values.decodeIfPresent(String.self, forKey: .genre)) ?? ""
            content = (try values.decodeIfPresent(String.self, forKey: .content)) ?? ""
            user = (try values.decodeIfPresent(UserInfo.self, forKey: .user)) ?? UserInfo()
            posterURL = (try values.decodeIfPresent(String.self, forKey: .posterURL)) ?? ""
            releaseDate = (try values.decodeIfPresent(Double.self, forKey: .releaseDate)) ?? 0
        } catch {
            
        }
        
        
    }
}
