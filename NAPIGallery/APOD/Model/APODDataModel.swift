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
    case none
}

struct APODDataModel: Codable {
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let media_type: String?
    let service_version: String?
    let title: String
    let url: String?
    
    func isImage() -> Bool {
        return media_type == "image"
    }
    
    func isVideo() -> Bool {
        return media_type == "video"
    }
    
    func mediaURL() -> URL? {
        if let theUrl = hdurl ?? url {
            return URL(string: theUrl)
        }
        return nil
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Keys.self)
//
//        try container.encode(title, forKey: .title)
//        try container.encode(description, forKey: .description)
//        try container.encode(url, forKey: .url)
//        try container.encode(copyright, forKey: .copyright)
//        try container.encode(mediaType, forKey: .mediaType)
//    }
//
//    required init(from decoder: Decoder) throws {
//        let valueContainer = try decoder.container(keyedBy: Keys.self)
//
//        self.title = try valueContainer.decode(String.self, forKey: Keys.title)
//        self.description = try valueContainer.decode(String.self, forKey: Keys.description)
//        self.url = try valueContainer.decode(URL.self, forKey: Keys.url)
//        self.copyright = try? valueContainer.decode(String.self, forKey: Keys.copyright)
//        self.mediaType = try valueContainer.decode(String.self, forKey: Keys.mediaType)
//    }
//
    init() {
        title = ""
        explanation = ""
        hdurl = nil
        url = nil
        copyright = ""
        date = "1970-01-01"
        media_type = ""
        service_version = "0"
    }
    
    #if DEBUG
    static func mockModel() -> APODDataModel {
        let json = """
    {
    "copyright": "Alvin Wu",
    "date": "2021-01-22",
    "explanation": "An expanse of cosmic dust, stars and nebulae along the plane of our Milky Way galaxy form a beautiful ring in this projected all-sky view. The creative panorama covers the entire galaxy visible from planet Earth, an ambitious 360 degree mosaic that took two years to complete. Northern hemisphere sites in western China and southern hemisphere sites in New Zealand were used to collect the image data. Like a glowing jewel set in the milky ring, the bulge of the galactic center, is at the very top. Bright planet Jupiter is the beacon just above the central bulge and left of red giant star Antares. Along the plane and almost 180 degrees from the galactic center, at the bottom of the ring is the area around Orion, denizen of the northern hemisphere's evening winter skies. In this projection the ring of the Milky Way encompasses two notable galaxies in southern skies, the large and small Magellanic clouds.",
    "hdurl": "https://apod.nasa.gov/apod/image/2101/MilkyWayRingAlvinWu.jpg",
    "media_type": "image",
    "service_version": "v1",
    "title": "The Milky Ring",
    "url": "https://apod.nasa.gov/apod/image/2101/MilkyWayRingAlvinWu1024.jpg"
    }
    """
        guard let data = json.data(using: .utf8) else { return APODDataModel() }
        guard let obj = try? JSONDecoder().decode(APODDataModel.self, from: data) else { return APODDataModel() }
        return obj
    }
    #endif
}
