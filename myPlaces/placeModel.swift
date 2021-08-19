//
//  placeModel.swift
//  myPlaces
//
//  Created by Стас Жингель on 17.08.2021.
//

import RealmSwift
import Realm


class Place: Object {
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var restourantImage: String?
    @objc dynamic var imageData: Data?
    @objc dynamic var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
  
}

