//
//  DataCinemaCreatedReturn.swift
//  CinemaBao
//
//  Created by macOS Sierra on 9/27/18.
//  Copyright © 2018 QuocBao. All rights reserved.
//

import Foundation

struct DataCinemaCreatedReturn: Codable {
  var name: String = ""
  var gerne: String = ""
  var releaseDate: Int64 = Int64(NSDate().timeIntervalSince1970)
  var content: String = ""
  var creatorId: String = ""
  
  enum CodingKeys: String, CodingKey {
    case name
    case gerne
    case releaseDate
    case content
    case creatorId
  }
}

extension DataCinemaCreatedReturn {
  init (from decoder: Decoder) throws
  {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = (try values.decodeIfPresent(String.self, forKey: .name)) ?? ""
    gerne = (try values.decodeIfPresent(String.self, forKey: .gerne)) ?? ""
    releaseDate = (try values.decodeIfPresent(Int64.self, forKey: .releaseDate)) ?? Int64(NSDate().timeIntervalSince1970)
    content = (try values.decodeIfPresent(String.self, forKey: .content)) ?? ""
    creatorId = (try values.decodeIfPresent(String.self, forKey: .creatorId)) ?? ""
  }
}
