//
//  ProfilesDataModel.swift
//  Party Organizer
//
//  Created by Dusan Dimic on 2/22/20.
//  Copyright © 2020 Dusan Dimic. All rights reserved.
//

import Foundation


struct Profiles : Decodable {
    let profiles : [Profile]?

    private enum CodingKeys: String, CodingKey {

        case profiles = "profiles"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        profiles = try values.decodeIfPresent([Profile].self, forKey: .profiles)
    }

}

struct Profile : Decodable {
    let id : Int?
    let username : String?
    let cell : String?
    let photo : String?
    let email : String?
    let gender : String?
    let aboutMe : String?

    private enum CodingKeys: String, CodingKey {

        case id = "id"
        case username = "username"
        case cell = "cell"
        case photo = "photo"
        case email = "email"
        case gender = "gender"
        case aboutMe = "aboutMe"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        cell = try values.decodeIfPresent(String.self, forKey: .cell)
        photo = try values.decodeIfPresent(String.self, forKey: .photo)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        aboutMe = try values.decodeIfPresent(String.self, forKey: .aboutMe)
    }

}
