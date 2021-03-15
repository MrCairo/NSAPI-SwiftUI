//
//  APODDataModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 3/7/21.
//

import Foundation

enum APODMediaType: Int, Codable {
    case imageURL
    case imageData
    case video
}

class APODDataModel: ObservableObject, Codable {
    @Published var title: String
    @Published var description: String
    @Published var url: URL?
    @Published var copyright: String?
    @Published var mediaType: String
    
    enum Keys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
        case mediaType = "media_type"
    }
    
    var isImage: Bool {
        return mediaType == "image"
    }
    
    var isVideo: Bool {
        return mediaType == "video"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(url, forKey: .url)
        try container.encode(copyright, forKey: .copyright)
        try container.encode(mediaType, forKey: .mediaType)
    }
        
    required init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: Keys.self)
        
        self.title = try valueContainer.decode(String.self, forKey: Keys.title)
        self.description = try valueContainer.decode(String.self, forKey: Keys.description)
        self.url = try valueContainer.decode(URL.self, forKey: Keys.url)
        self.copyright = try? valueContainer.decode(String.self, forKey: Keys.copyright)
        self.mediaType = try valueContainer.decode(String.self, forKey: Keys.mediaType)
    }
    
    init() {
        title = ""
        description = ""
        url = nil
        copyright = ""
        mediaType = ""
    }
}
