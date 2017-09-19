//
//  Polygon.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 02/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import Foundation
import Mapbox

/*52.953384, -1.185587
52.953171, -1.185453
52.953074, -1.186011
52.953313, -1.186112

*/
let POLYGON_SOUTHWELLHALL = Polygon(id: .southwellHall, coordinates:
    [
    CLLocationCoordinate2D(latitude: 52.953384, longitude: -1.185587),
    CLLocationCoordinate2D(latitude: 52.953171, longitude: -1.185453),
    CLLocationCoordinate2D(latitude: 52.953074, longitude: -1.186011),
    CLLocationCoordinate2D(latitude: 52.953313, longitude: -1.186112)
    ], hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.953242, longitude: -1.185862), hiddenMarker2Cord: nil)

let POLYGON_BICYCLE_STORAGE = Polygon(id: .southwellHall, coordinates: [CLLocationCoordinate2D(latitude: 52.953799, longitude: -1.186951),
                                                                        CLLocationCoordinate2D(latitude: 52.953811, longitude: -1.187125),
                                                                        CLLocationCoordinate2D(latitude: 52.953906, longitude: -1.187222),
                                                                        CLLocationCoordinate2D(latitude: 52.953954, longitude: -1.187093)], hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.9533, longitude: -1.1859), hiddenMarker2Cord: nil)

let POLYGON_EXCHANGE_BICYCLE_PARK = Polygon(id: .southwellHall, coordinates: [CLLocationCoordinate2D(latitude: 52.954162, longitude: -1.188540),
                                                                              CLLocationCoordinate2D(latitude: 52.954124, longitude: -1.188437),
                                                                              CLLocationCoordinate2D(latitude: 52.954226, longitude: -1.188236),
                                                                              CLLocationCoordinate2D(latitude: 52.954317, longitude: -1.188423)], hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.954163, longitude: -1.188427), hiddenMarker2Cord: nil)

let POLYGON_COLIN_CAMPBELL_BUILDING = Polygon(id: .southwellHall, coordinates: [CLLocationCoordinate2D(latitude: 52.950973, longitude: -1.184051),
                                                                                CLLocationCoordinate2D(latitude: 52.951092, longitude: -1.184252),
                                                                                CLLocationCoordinate2D(latitude: 52.951072, longitude: -1.184476),
                                                                                CLLocationCoordinate2D(latitude: 52.951024, longitude: -1.184500),
                                                                                CLLocationCoordinate2D(latitude: 52.951054, longitude: -1.184051)], hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.951092, longitude: -1.184252), hiddenMarker2Cord: nil)

let POLYGON_BENFORD_ROOM_AREA_AND_LAB = Polygon(id: .southwellHall, coordinates: [CLLocationCoordinate2D(latitude: 52.953470, longitude: -1.187679),
                                                                                  CLLocationCoordinate2D(latitude: 52.953570, longitude: -1.187162),
                                                                                  CLLocationCoordinate2D(latitude: 52.953218, longitude: -1.186950),
                                                                                  CLLocationCoordinate2D(latitude: 52.953130, longitude: -1.187473)], hiddenMarkerCord:
    CLLocationCoordinate2D(latitude: 52.953023, longitude: -1.187413), hiddenMarker2Cord: CLLocationCoordinate2D(latitude: 52.953023, longitude: -1.187413))

let POLYGON_VERE_CENTRE = Polygon(id: .southwellHall, coordinates: [CLLocationCoordinate2D(latitude: 52.950254, longitude: -1.185873), CLLocationCoordinate2D(latitude: 52.950461, longitude: -1.186292), CLLocationCoordinate2D(latitude: 52.950651, longitude: -1.185506), CLLocationCoordinate2D(latitude: 52.950375, longitude: -1.185471)], hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.950335, longitude: -1.185956), hiddenMarker2Cord: nil)

let CIRCLE_SI_YUAN_BIN = Circle(id: .southwellHall, centerCord: CLLocationCoordinate2D(latitude: 52.951209, longitude: -1.185800), meterRadius: 6, hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.951209, longitude: -1.185800))

let CIRCLE_BUS_STOP_RA63_CHAIRS = Circle(id: .southwellHall, centerCord: CLLocationCoordinate2D(latitude: 52.954091, longitude: -1.187779), meterRadius: 3, hiddenMarkerCord: CLLocationCoordinate2D(latitude: 52.954085, longitude: -1.187767))

struct Polygon{
    var id: PolygonId!
    var coordinates : [CLLocationCoordinate2D]
    var hiddenMarkerCord : CLLocationCoordinate2D
    var hiddenMarker2Cord : CLLocationCoordinate2D!
}

struct Circle{
    var id: PolygonId!
    var centerCord : CLLocationCoordinate2D
    var meterRadius: Double
    var hiddenMarkerCord : CLLocationCoordinate2D
}
