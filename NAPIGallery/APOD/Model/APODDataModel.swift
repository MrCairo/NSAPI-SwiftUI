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
    private(set) var copyright: String?
    private(set) var date: String?
    private(set) var explanation: String?
    private(set) var hdurl: String?
    private(set) var media_type: String?
    private(set) var service_version: String?
    private(set) var title: String
    private(set) var url: String?
    
    func isImage() -> Bool {
        return media_type == "image"
    }
    
    func isVideo() -> Bool {
        return media_type == "video"
    }
    
    func mediaURL() -> URL? {
        if let theUrl = url ?? hdurl {
            return URL(string: theUrl)
        }
        return nil
    }
    
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
    
    init(asFailure: Bool) {
        self.init()
        if asFailure {
            title = "FAILURE"
            explanation = "Failed to fetch real APOD data"
            hdurl = nil
            url = nil
            copyright = ""
            date = "1970-01-01"
            media_type = ""
            service_version = "0"
        }
    }
    
    #if DEBUG
    static var mockImageModel: APODDataModel {
        let json = """
    {"copyright":"Alvin Wu","date":"2021-01-22","explanation":"An expanse of cosmic dust, stars and nebulae along the plane of our Milky Way galaxy form a beautiful ring in this projected all-sky view. The creative panorama covers the entire galaxy visible from planet Earth, an ambitious 360 degree mosaic that took two years to complete. Northern hemisphere sites in western China and southern hemisphere sites in New Zealand were used to collect the image data. Like a glowing jewel set in the milky ring, the bulge of the galactic center, is at the very top. Bright planet Jupiter is the beacon just above the central bulge and left of red giant star Antares. Along the plane and almost 180 degrees from the galactic center, at the bottom of the ring is the area around Orion, denizen of the northern hemisphere's evening winter skies. In this projection the ring of the Milky Way encompasses two notable galaxies in southern skies, the large and small Magellanic clouds.","hdurl":"https://apod.nasa.gov/apod/image/2101/MilkyWayRingAlvinWu.jpg","media_type":"image","service_version":"v1","title":"The Milky Ring","url":"https://apod.nasa.gov/apod/image/2101/MilkyWayRingAlvinWu1024.jpg"}
    """
        guard let data = json.data(using: .utf8) else { return APODDataModel() }
        guard let obj = try? JSONDecoder().decode(APODDataModel.self, from: data) else { return APODDataModel() }
        return obj
    }
    
    static var mockVideoModel: APODDataModel {
        let json = """
    {"date":"2021-04-01","explanation":"Have you ever seen a rocket launch -- from space?  A close inspection of the featured time-lapse video will reveal a rocket rising to Earth orbit as seen from the International Space Station (ISS).  The Russian Soyuz-FG rocket was launched in November 2018 from the Baikonur Cosmodrome in Kazakhstan, carrying a Progress MS-10 (also 71P) module to bring needed supplies to the ISS.  Highlights in the 90-second video (condensing about 15-minutes) include city lights and clouds visible on the Earth on the lower left, blue and gold bands of atmospheric airglow running diagonally across the center, and distant stars on the upper right that set behind the Earth. A lower stage can be seen falling back to Earth as the robotic supply ship fires its thrusters and begins to close on the ISS, a space laboratory that celebrated its 20th anniversary in 2018. Astronauts who live aboard the Earth-orbiting ISS conduct, among more practical duties, numerous science experiments that expand human knowledge and enable future commercial industry in low Earth orbit.","media_type":"video","service_version":"v1","title":"Rocket Launch as Seen from the Space Station","url":"https://www.youtube.com/embed/B1R3dTdcpSU?rel=0"}
    """
        guard let data = json.data(using: .utf8) else { return APODDataModel() }
        guard let obj = try? JSONDecoder().decode(APODDataModel.self, from: data) else { return APODDataModel() }
        return obj
    }
    #endif
}
