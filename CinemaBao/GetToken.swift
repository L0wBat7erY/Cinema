//
//  GetToken.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/26/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation

struct GetToken: Codable {
    var token: String = ""
    var user: UserInfo = UserInfo()
    var status: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case token
        case user
        case status
    }
}

extension GetToken {
    init(from decoder: Decoder) throws
        {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                token = (try values.decodeIfPresent(String.self, forKey: .token)) ?? ""
                user = (try values.decodeIfPresent(UserInfo.self, forKey: .user)) ?? UserInfo()
                status = (try values.decodeIfPresent(Int.self, forKey: .status)) ?? 0
        }
}
