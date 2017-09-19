//
//  MapboxExtensions.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 02/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import Foundation
import Mapbox
import MapKit

extension EXMGLPolygon{
    
    class func polygonCircleForCoordinate(coordinate: CLLocationCoordinate2D, withMeterRadius: Double) -> EXMGLPolygon{
        let degreesBetweenPoints = 8.0
        let numberOfPoints = floor(360.0 / degreesBetweenPoints)
        let distRadians: Double = withMeterRadius / 6371000.0
        let centerLatRadians: Double = coordinate.latitude * M_PI / 180
        let centerLonRadians: Double = coordinate.longitude * M_PI / 180
        var coordinates = [CLLocationCoordinate2D]()
        
        for index in 0 ..< Int(numberOfPoints) {
            let degrees: Double = Double(index) * Double(degreesBetweenPoints)
            let degreeRadians: Double = degrees * M_PI / 180
            let pointLatRadians: Double = asin(sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians))
            let pointLonRadians: Double = centerLonRadians + atan2(sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians), cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians))
            let pointLat: Double = pointLatRadians * 180 / M_PI
            let pointLon: Double = pointLonRadians * 180 / M_PI
            let point: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pointLat, pointLon)
            coordinates.append(point)
        }
        
        return EXMGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
    }
    
    //TODO: Combine below two methods to a one and implement the containsPoint inside a polygon
    
    /*Scan and Win*/
    
    func containsSouthwellHallPolygonCoord(coordinate : CLLocationCoordinate2D, mapView : MGLMapView) -> Bool{
        return false
    }

    func containsSouthwellHallHotspotCoord(coordinate : CLLocationCoordinate2D, mapView : MGLMapView) -> Bool{
        return false
    }
    
    /*Scan and Win + Warning + Riddle*/
    
    func containsVereCentrePolygonCoord(coordinate : CLLocationCoordinate2D, mapView : MGLMapView) -> Bool{
        return false
    }

    func containsVereCentreHotspotCoord(coordinate : CLLocationCoordinate2D, mapView : MGLMapView) -> Bool{
        return false
    }

    func containsColinCampbellPolygonCoord(coordinate : CLLocationCoordinate2D, mapView : MGLMapView) -> Bool{
        return false
    }
    
    func containsColinCampbellHotspotCoord(coordinate : CLLocationCoordinate2D, mapView : MGLMapView) -> Bool{
        return false
    }

}
