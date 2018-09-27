//
//  ListInfoSignUp.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/27/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation

struct ListInfoSignUp: Codable {
    var user: UserInfo = UserInfo()
    var message: String = ""
    var status = Int()
    
    enum CodingKeys: String, CodingKey {
        case user
        case status
        case message
    }
    
}

extension ListInfoSignUp {
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = (try values.decodeIfPresent(UserInfo.self, forKey: .user)) ?? UserInfo()
        status = (try values.decodeIfPresent(Int.self, forKey: .status)) ?? 0
        message = (try values.decodeIfPresent(String.self, forKey: .message)) ?? ""
    }
}
