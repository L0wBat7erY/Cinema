//
//  ClassInfoUser.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/24/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
  var _id: String = ""
  var email: String = ""
  var password: String = ""
  var name: String = ""
  var avatarURL: String = ""
  
  enum CodingKeys: String, CodingKey {
    case _id
    case email
    case password
    case name
    case avatarURL
  }
  
  init() {}
}

extension UserInfo {
  init (from decoder: Decoder) throws
  {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    _id = (try values.decodeIfPresent(String.self, forKey: ._id)) ?? ""
    email = (try values.decodeIfPresent(String.self, forKey: .email)) ?? ""
    password = (try values.decodeIfPresent(String.self, forKey: .password)) ?? ""
    name = (try values.decodeIfPresent(String.self, forKey: .name)) ?? ""
    avatarURL = (try values.decodeIfPresent(String.self, forKey: .avatarURL)) ?? ""
  }
}
