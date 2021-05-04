//
//  RoverInfoModel.swift
//  NAPIGallery
//
//  Created by Mitch Fisher on 4/16/21.
//

import Foundation

final class RoverInformationModel: Codable {
    private(set) var id: Int
    private(set) var name: String
    private(set) var landing_date: String?
    private(set) var launch_date: String?
    private(set) var status: String?
    private(set) var max_sol: Int?
    private(set) var max_date: String?
    private(set) var total_photos: Int?
    private(set) var cameras: [RoverCameraModel]
    
    init() {
        id = -1
        name = "undefined"
        landing_date = ""
        launch_date = ""
        status = ""
        max_sol = -1
        max_date = ""
        total_photos = -1
        cameras = [RoverCameraModel]()
    }
}

final class RoverWikipediaModel {
}

/*
 {
   "rover": {
     "id": 7,
     "name": "Spirit",
     "landing_date": "2004-01-04",
     "launch_date": "2003-06-10",
     "status": "complete",
     "max_sol": 2208,
     "max_date": "2010-03-21",
     "total_photos": 124550,
     "cameras": [
       {
         "name": "FHAZ",
         "full_name": "Front Hazard Avoidance Camera"
       },
       {
         "name": "NAVCAM",
         "full_name": "Navigation Camera"
       },
       {
         "name": "PANCAM",
         "full_name": "Panoramic Camera"
       },
       {
         "name": "MINITES",
         "full_name": "Miniature Thermal Emission Spectrometer (Mini-TES)"
       },
       {
         "name": "ENTRY",
         "full_name": "Entry, Descent, and Landing Camera"
       },
       {
         "name": "RHAZ",
         "full_name": "Rear Hazard Avoidance Camera"
       }
     ]
   }
 } */

/* Spirit Rover Info:
 Mission type    Rover
 Operator    NASA
 COSPAR ID    2003-027A
 SATCAT no.    27827Edit this on Wikidata
 Website    Mars Exploration Rover
 Mission duration    Planned: 90 Martian solar days (~92 Earth days)
 Operational: 2269 days from landing to last contact (2208 sols)
 Mobile: 1944 Earth days landing to final embedding (1892 sols)
 Total: 2695 days from landing to mission end (2623 sols)
 Launch to last contact: 6 years, 9 months, 12 days
 Spacecraft properties
 Spacecraft type    Mars Exploration Rover
 Launch mass    1,063 kg: rover 185 kg, lander 348 kg, backshell/parachute 209 kg, heat shield 78 kg, cruise stage 193 kg, propellant 50 kg[1]
 Dry mass    185 kilograms (408 lb) (Rover only)
 Power    140 watts
 Start of mission
 Launch date    June 10, 2003, 1:58:47 p.m. EDT[2][3]
 Rocket    Delta II 7925-9.5[3][4]
 Launch site    Cape Canaveral SLC-17A
 End of mission
 Declared    May 25, 2011[2]
 Last contact    March 22, 2010
 Orbital parameters
 Reference system    Heliocentric (transfer)
 Mars rover
 Spacecraft component    Rover
 Landing date    January 4, 2004, 04:35 UTC SCET
 MSD 46216 03:35 AMT
 Landing site    14.5684°S 175.472636°E[5]
 Distance covered    7.73 km (4.8 mi)

 */
