//
//  EXMGLPolygon.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 09/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import Mapbox
import UserNotifications
import AudioToolbox

enum PolygonId {
    case southwellHall
    case southwellHallMarkerHotspot
    case southwellHallMarker2Hotspot
    case vereCentre
    case vereCentreHotspot
    case collinCampbell
    case collinCampbellHotspot
    case other
}

protocol EXMGLPolygonDelegate : class {
    func presentAlert(alertVC : PMAlertController)
    func playBackgroundMusic(audio : NSDataAsset)
    func startTimer(duration : Int, hotspot : EXMGLPolygon)
}

class EXMGLPolygon : MGLPolygon{
    weak var delegate : EXMGLPolygonDelegate?
    var id: PolygonId = .other
    var userEntered : Bool!
    var didTriggerExpr : Bool = false
    
    func triggerUserExpr(){
        switch id{
        case .southwellHall,
             .vereCentre,
             .collinCampbell:
            showDetectedAlert(id: id)
            startTheBackgroundMusic(id: id)
        case .southwellHallMarkerHotspot,
             .vereCentreHotspot,
             .collinCampbellHotspot:
            startHotspotExperience(id: id)
        case .other:
            break
        default:
            break
        }
        didTriggerExpr = true
    }
    
    func stopUserExpr(){
        if didTriggerExpr{
            didTriggerExpr = false
        }
    }
    
    func showDetectedAlert(id: PolygonId) {
        var image : UIImage!
        var msg : String!
        
        switch id{
        case .southwellHall:
            image = #imageLiteral(resourceName: "icon_6")
            msg = "You are near to the above marker. Search around this area to find it and scan it to unlock one of the letters in the Amazon voucher code."
        case .vereCentre:
            image = #imageLiteral(resourceName: "icon_7")
            msg = "You are near to the above marker. Search around this area to find it. After scanning it you'll get a chance to solve an interesting riddle and unlock one of the letters in the Amazon voucher code."
        case .collinCampbell:
            image = #imageLiteral(resourceName: "icon_8")
            msg = "You are near to the above marker. Search around this area to find it. After scanning it you'll get a chance to solve an interesting riddle and unlock one of the letters in the Amazon voucher code."
        default:
            break
        }

        let alertVC = PMAlertController(title: "Marker Detected!", description: msg, image: image, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Ok", style: .default, action: nil))
        alertVC.addAction(PMAlertAction(title: "I'll try later", style: .cancel, action: nil))

        delegate?.presentAlert(alertVC: alertVC)
    }
    
    func startTheBackgroundMusic(id: PolygonId){
        var audioName : String!
        
        switch id{
        case .southwellHall:
            audioName = "phantom_menace"
        case .vereCentre:
            audioName = "attack_of_the_clones"
        case .collinCampbell:
            audioName = "attack_of_the_clones"
        default:
            break
        }
        guard let audio = NSDataAsset(name: audioName) else {
            print("background audio not found")
            return
        }
        delegate?.playBackgroundMusic(audio: audio)
    }
    
    func startHotspotExperience(id: PolygonId){
        var image : UIImage!
        var msg : String!
        var duration: Int!
        
        switch id{
        case .southwellHallMarkerHotspot:
            image = #imageLiteral(resourceName: "icon_6")
            msg = "You are now 2.5 meters away from the marker. You'll get 2 minutes to find and scan this marker. Would you like to start now?"
            duration = 120
        case .vereCentreHotspot:
            image = #imageLiteral(resourceName: "icon_7")
            msg = "You are now 3 meters away from the marker. You'll get 3 minutes to find and scan this marker. Would you like to start now?"
             duration = 180
        case .collinCampbell:
            image = #imageLiteral(resourceName: "icon_7")
            msg = "You are now 1 meters away from the marker. You'll get 1 minutes to find and scan this marker. Would you like to start now?"
            duration = 60
        default:
            break
        }
        
        let alertVC = PMAlertController(title: "Marker is Closeby!", description: msg, image: image, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Yes", style: .default,  action: { () -> Void in
            self.delegate?.startTimer(duration: duration, hotspot: self)
        }))
        alertVC.addAction(PMAlertAction(title: "I'll try later", style: .cancel, action: nil))
     
        delegate?.presentAlert(alertVC: alertVC)

    }
}
