//
//  MapViewController.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 28/02/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation
import AVFoundation

class MapViewController: UIViewController {
    
    //MARK:- Properties
    
    @IBOutlet var exMapView: MGLMapView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!

    var locationManager: CLLocationManager = CLLocationManager()
    var didDetectWeatherCondition : Bool!
    var startLocation : CLLocation!
    var bgAudioPlayer : AVAudioPlayer!
    var countdownValue : Int = 0
    var countdownTimer : Timer!
    var currentHotspot : EXMGLPolygon!
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
        }catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        exMapView.userTrackingMode = .follow
        exMapView.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func promptToSwitchToOfflineMode(){
        let alertVC = PMAlertController(title: "Bad network connection", description: "It seems you have having a bad network connection. Please switch to the offline mode now to continue playing.", image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Switch to offline", style: .default,   action: { () -> Void in
            self.performSegue(withIdentifier: "goToOfflineMap", sender: self)
        }))
        
        alertVC.addAction(PMAlertAction(title: "I'll play later", style: .cancel,   action: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        drawOverlayShapes()
        addHiddenMarkers()

        /*Prompting for the offline mode when low network or no network*/
        //promptToSwitchToOfflineMode()
    }
    
    func drawOverlayShapes() {
        let southwellHallPolygon = EXMGLPolygon(coordinates: POLYGON_SOUTHWELLHALL.coordinates, count: UInt(POLYGON_SOUTHWELLHALL.coordinates.count))
        southwellHallPolygon.id = .southwellHall
        southwellHallPolygon.delegate = self
        
        let bicycleStoragePolygon = EXMGLPolygon(coordinates: POLYGON_BICYCLE_STORAGE.coordinates, count: UInt(POLYGON_BICYCLE_STORAGE.coordinates.count))
        bicycleStoragePolygon.id = .other
        bicycleStoragePolygon.delegate = self
        
        let stopRA63ChairsPolygon = EXMGLPolygon.polygonCircleForCoordinate(coordinate: CIRCLE_BUS_STOP_RA63_CHAIRS.centerCord, withMeterRadius: CIRCLE_BUS_STOP_RA63_CHAIRS.meterRadius)
        stopRA63ChairsPolygon.id = .other
        stopRA63ChairsPolygon.delegate = self
        
        let exchangeBicycleParkPolygon = EXMGLPolygon(coordinates: POLYGON_EXCHANGE_BICYCLE_PARK.coordinates, count: UInt(POLYGON_EXCHANGE_BICYCLE_PARK.coordinates.count))
        exchangeBicycleParkPolygon.id = .other
        exchangeBicycleParkPolygon.delegate = self
        
        let siYuanBinPolygon = EXMGLPolygon.polygonCircleForCoordinate(coordinate: CIRCLE_SI_YUAN_BIN.centerCord, withMeterRadius: CIRCLE_SI_YUAN_BIN.meterRadius)
        siYuanBinPolygon.id = .other
        siYuanBinPolygon.delegate = self
        
        let colinCampbelPondPolygon = EXMGLPolygon(coordinates: POLYGON_COLIN_CAMPBELL_BUILDING.coordinates, count: UInt(POLYGON_COLIN_CAMPBELL_BUILDING.coordinates.count))
        colinCampbelPondPolygon.id = .collinCampbell
        colinCampbelPondPolygon.delegate = self
        
        let benfordRoomAreaPolygon = EXMGLPolygon(coordinates: POLYGON_BENFORD_ROOM_AREA_AND_LAB.coordinates, count: UInt(POLYGON_BENFORD_ROOM_AREA_AND_LAB.coordinates.count))
        benfordRoomAreaPolygon.id = .other
        benfordRoomAreaPolygon.delegate = self
        
        let vereCentrePolygon = EXMGLPolygon(coordinates: POLYGON_VERE_CENTRE.coordinates, count: UInt(POLYGON_VERE_CENTRE.coordinates.count))
        vereCentrePolygon.id = .vereCentre
        vereCentrePolygon.delegate = self

        exMapView.addAnnotations([southwellHallPolygon, bicycleStoragePolygon, stopRA63ChairsPolygon, exchangeBicycleParkPolygon, siYuanBinPolygon, colinCampbelPondPolygon, vereCentrePolygon, benfordRoomAreaPolygon])
    }
    
    //TODO: Only for testing
    func addHiddenMarkers(){
        let southwellHallMarkerHotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_SOUTHWELLHALL.hiddenMarkerCord, withMeterRadius: 2.5)
        southwellHallMarkerHotspot.id = .southwellHallMarkerHotspot
        southwellHallMarkerHotspot.delegate = self
        
        let vereCentreHotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_VERE_CENTRE.hiddenMarkerCord, withMeterRadius: 3)
        vereCentreHotspot.id = .vereCentreHotspot
        vereCentreHotspot.delegate = self

        let collinCampbellHotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_COLIN_CAMPBELL_BUILDING.hiddenMarkerCord, withMeterRadius: 1)
        collinCampbellHotspot.id = .collinCampbellHotspot
        collinCampbellHotspot.delegate = self
        
        exMapView.addAnnotations([southwellHallMarkerHotspot, vereCentreHotspot, collinCampbellHotspot])
    }
    
    //For Scan and Win
    func showShouthwellHallHiddenMarker(){
        let southwellHallMarker = MGLPointAnnotation()
        southwellHallMarker.coordinate = POLYGON_SOUTHWELLHALL.hiddenMarkerCord
        southwellHallMarker.title = "Phantom Menance"
        southwellHallMarker.subtitle = "The clue was referring to the sliding door"
        
        let southwellHallMarkerHotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_SOUTHWELLHALL.hiddenMarkerCord, withMeterRadius: 2.5)
        southwellHallMarkerHotspot.id = .southwellHallMarkerHotspot
        southwellHallMarkerHotspot.delegate = self
        
        exMapView.addAnnotations([southwellHallMarker, southwellHallMarkerHotspot])
    }
    
    func showVereCentreHiddenMarker(){
        let vereCentreMarker = MGLPointAnnotation()
        vereCentreMarker.coordinate = POLYGON_VERE_CENTRE.hiddenMarkerCord
        vereCentreMarker.title = "Attack of the Clones"
        vereCentreMarker.subtitle = "The clue was referring to green grass"
        
        let vereCentreMarkerHotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_VERE_CENTRE.hiddenMarkerCord, withMeterRadius: 3)
        vereCentreMarkerHotspot.id = .vereCentreHotspot
        vereCentreMarkerHotspot.delegate = self
        
        exMapView.addAnnotations([vereCentreMarker, vereCentreMarkerHotspot])
    }
    
    func showCollinCampbellHiddenMarker(){
        let collinCampbellMarker = MGLPointAnnotation()
        collinCampbellMarker.coordinate = POLYGON_COLIN_CAMPBELL_BUILDING.hiddenMarkerCord
        collinCampbellMarker.title = "Revenge of the Sith"
        
        let collinCampbellMarkerHotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_COLIN_CAMPBELL_BUILDING.hiddenMarkerCord, withMeterRadius: 1)
        collinCampbellMarkerHotspot.id = .collinCampbellHotspot
        collinCampbellMarkerHotspot.delegate = self
        
        exMapView.addAnnotations([collinCampbellMarker, collinCampbellMarkerHotspot])
    }

    
    func showShouthwellHallHiddenMarker2(){
        let southwellHallMarker2 = MGLPointAnnotation()
        southwellHallMarker2.coordinate = POLYGON_SOUTHWELLHALL.hiddenMarker2Cord
        southwellHallMarker2.title = "Southwell Hall Hidden Marker 2"
        southwellHallMarker2.subtitle = "Outdoor Challenge: Hidden Marker 2"
        
        let southwellHallMarker2Hotspot = EXMGLPolygon.polygonCircleForCoordinate(coordinate: POLYGON_SOUTHWELLHALL.hiddenMarker2Cord, withMeterRadius: 2.5)
        southwellHallMarker2Hotspot.id = .southwellHallMarker2Hotspot
        southwellHallMarker2Hotspot.delegate = self
        exMapView.addAnnotations([southwellHallMarker2, southwellHallMarker2Hotspot])
    }
    
    //For show the crowd
    func showRA63BusTopMarker(){
        let ra63Marker = MGLPointAnnotation()
        ra63Marker.coordinate = CIRCLE_BUS_STOP_RA63_CHAIRS.hiddenMarkerCord
        ra63Marker.title = "10 Explorers in this area"
        exMapView.addAnnotation(ra63Marker)
    }
    
    func showExchangeBicycleParkMarker(){
        let exchangeBicycleParkMarker = MGLPointAnnotation()
        exchangeBicycleParkMarker.coordinate = POLYGON_EXCHANGE_BICYCLE_PARK.hiddenMarkerCord
        exchangeBicycleParkMarker.title = "4 Explorers in this area"
        exMapView.addAnnotation(exchangeBicycleParkMarker)
    }
}

//MARK: - EXMGLPolygonDelegate

extension MapViewController : EXMGLPolygonDelegate{
    func presentAlert(alertVC: PMAlertController) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func playBackgroundMusic(audio: NSDataAsset) {
        do {
            bgAudioPlayer = try AVAudioPlayer(data: audio.data, fileTypeHint: AVFileTypeWAVE)
            bgAudioPlayer.prepareToPlay()
            bgAudioPlayer.play()
            bgAudioPlayer.numberOfLoops = 100
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func stopAllMusic() {
        if let player = bgAudioPlayer{
            player.stop()
        }
    }
    
    func startTimer(duration: Int, hotspot: EXMGLPolygon){
        countdownValue = duration
        timerLabel.isHidden = false
        currentHotspot = hotspot
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
    }
    
    func updateCounter() {
        if countdownValue > 0 {
            let minutes = Int(countdownValue) / 60 % 60
            let seconds = Int(countdownValue) % 60
            timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
            countdownValue -= 1
        }
        
        if countdownValue == 60{
            var msg : String!
            var image : UIImage!
            
            switch currentHotspot.id{
            case .southwellHallMarkerHotspot:
                msg = "Want a clue?\nDoes the above picture from Phantom Menance movie indicate anything in this area?"
                image = #imageLiteral(resourceName: "clue_1")
            case .vereCentreHotspot:
                msg = "Want a clue?\nDoes the above picture from Attack of the Clones movie indicate anything in this area?"
                image = #imageLiteral(resourceName: "clue_2")
            default:
                break
            }
            let alertVC = PMAlertController(title: "You have only 1 minute left!", description: msg, image: image, style: .alert)
            alertVC.addAction(PMAlertAction(title: "Ok", style: .default,  action: nil))
            presentAlert(alertVC: alertVC)
        }
        
        if countdownValue == 0{
            countdownTimer.invalidate()
            
            timerLabel.text = "00:00"
            let alertVC = PMAlertController(title: "Times Up!", description: "Would you like to reveal the marker? Please note revealing this marker will be reducing 10% from your Amazon voucher!", image: nil, style: .alert)
            alertVC.addAction(PMAlertAction(title: "Yes", style: .default,   action: { () -> Void in
                switch self.currentHotspot.id{
                case .southwellHallMarkerHotspot:
                    self.showShouthwellHallHiddenMarker()
                    self.exMapView.setCenter(POLYGON_SOUTHWELLHALL.hiddenMarkerCord, zoomLevel: 25, animated: true)
                case .vereCentreHotspot:
                    self.showVereCentreHiddenMarker()
                    self.exMapView.setCenter(POLYGON_VERE_CENTRE.hiddenMarkerCord, zoomLevel: 10, animated: true)
                case .collinCampbellHotspot:
                    self.showCollinCampbellHiddenMarker()
                    self.exMapView.setCenter(POLYGON_COLIN_CAMPBELL_BUILDING.hiddenMarkerCord, zoomLevel: 10, animated: true)
                default:
                    break
                }
                }))
            alertVC.addAction(PMAlertAction(title: "I'll try later", style: .cancel,  action: nil))
            presentAlert(alertVC: alertVC)
            
        }
    }
}

//MARK: - MGLMapViewDelegate

extension MapViewController: MGLMapViewDelegate{
    
    func mapView(_ mapView: MGLMapView, didUpdate userLocation: MGLUserLocation?) {
        checkUserDistance(userLocation: userLocation)
        
        if let annotations = mapView.annotations{
            for annotation in annotations{
                if annotation.isKind(of: EXMGLPolygon.classForCoder()){
                    let polygon = annotation as! EXMGLPolygon
                    switch polygon.id{
                    case .southwellHall:
                        if polygon.containsSouthwellHallPolygonCoord(coordinate: (mapView.userLocation?.coordinate)!, mapView: mapView){
                            if polygon.didTriggerExpr{
                                return
                            }
                            stopAllMusic()
                            polygon.triggerUserExpr()
                        }else{
                            polygon.stopUserExpr()
                            stopAllMusic()
                        }
                    case .southwellHallMarkerHotspot:
                        if polygon.containsSouthwellHallHotspotCoord(coordinate: (mapView.userLocation?.coordinate)!, mapView: mapView){
                            if polygon.didTriggerExpr{
                                return
                            }
                            stopAllMusic()
                            polygon.triggerUserExpr()
                        }else{
                            polygon.stopUserExpr()
                            stopAllMusic()
                        }
                    case .vereCentre:
                        if polygon.containsVereCentrePolygonCoord(coordinate: (mapView.userLocation?.coordinate)!, mapView: mapView){
                            if polygon.didTriggerExpr{
                                return
                            }
                            warningLabel.text = "DANGER! DEEP WATER"
                            warningLabel.isHidden = false
                            stopAllMusic()
                            polygon.triggerUserExpr()
                        }else{
                            polygon.stopUserExpr()
                            stopAllMusic()
                        }
                    case .vereCentreHotspot:
                        if polygon.containsVereCentreHotspotCoord(coordinate: (mapView.userLocation?.coordinate)!, mapView: mapView){
                            if polygon.didTriggerExpr{
                                return
                            }
                            warningLabel.text = "DANGER! DEEP WATER"
                            warningLabel.isHidden = false
                            stopAllMusic()
                            polygon.triggerUserExpr()
                        }else{
                            polygon.stopUserExpr()
                            stopAllMusic()
                        }
                    case .collinCampbell:
                        if polygon.containsColinCampbellPolygonCoord(coordinate: (mapView.userLocation?.coordinate)!, mapView: mapView){
                            if polygon.didTriggerExpr{
                                return
                            }
                            warningLabel.text = "CAUTION! DO NOT DISTURB OTHERS"
                            warningLabel.isHidden = false

                            infoLabel.text = "Seems you are moving towards the wrong direction!"
                            infoLabel.isHidden = false
                            stopAllMusic()
                            polygon.triggerUserExpr()
                        }else{
                            polygon.stopUserExpr()
                            stopAllMusic()
                        }
                    case .collinCampbellHotspot:
                        if polygon.containsColinCampbellHotspotCoord(coordinate: (mapView.userLocation?.coordinate)!, mapView: mapView){
                            if polygon.didTriggerExpr{
                                return
                            }
                            warningLabel.text = "CAUTION! DO NOT DISTURB OTHERS"
                            warningLabel.isHidden = false
                            stopAllMusic()
                            polygon.triggerUserExpr()
                        }else{
                            polygon.stopUserExpr()
                            stopAllMusic()
                        }
                    default:
                        break
                    }
                }
                
            }
        }
    }
    
    //MARK: - User Distance Tracking
    
    fileprivate func checkUserDistance(userLocation: MGLUserLocation?){
        if let startLocation = startLocation{
            let distanceInMeters = startLocation.distance(from: CLLocation(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!))
            let distanceInMiles = distanceInMeters / 1609.344
            if distanceInMiles > 1{
                let warningMsg = String(format:"Your are currently %.2f miles away from where you've started.", 0.83)
                
                let alertVC = PMAlertController(title: "Warning", description: warningMsg, image: nil, style: .alert)
                alertVC.addAction(PMAlertAction(title: "Take me back", style: .default,   action: { ()-> Void in
                    let directionsURL = String(format:"http://maps.apple.com/?saddr=Current%%20Location&daddr=%f,%f", startLocation.coordinate.latitude, startLocation.coordinate.longitude)
                    if let url = URL(string: directionsURL) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }))
                alertVC.addAction(PMAlertAction(title: "Continue", style: .cancel,   action: nil))
                present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .white
    }
    
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return .mapOrange()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate{
    
    //MARK: - Weather Warning
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: CLLocation = locations[locations.count - 1]
        startLocation = latestLocation
        
        let lat = latestLocation.coordinate.latitude
        let lon = latestLocation.coordinate.longitude
        
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=62b5d7f5cf0d5925d5383382cd567091"
        let url = NSURL(string: path)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                self.extractWeatherData(weatherData: data! as NSData)
            })
        }
        task.resume()
    }
    
    func extractWeatherData(weatherData: NSData) {
        let json = try? JSONSerialization.jsonObject(with: weatherData as Data, options: []) as! NSDictionary
        if json != nil {
            locationManager.stopUpdatingLocation()
            
            if let array = json!["weather"] as? [NSDictionary] {
                if array.count == 0{
                    return
                }
                if let weatherId = array[0]["id"]{
                    
                    if (weatherId as! Int) < 800 || (weatherId as! Int) >= 900{
                        if let weatherDescription = array[0]["description"] as? String{
                            let warningMsg = String(format:"It seems like the outside weather condition is \"%@\". Would you like to play the indoor challenge instead?", weatherDescription)
                            
                            let alertVC = PMAlertController(title: "Warning", description: warningMsg, image: nil, style: .alert)
                            alertVC.addAction(PMAlertAction(title: "Yes", style: .default,   action: nil))
                            alertVC.addAction(PMAlertAction(title: "No", style: .cancel,   action: nil))
                            present(alertVC, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - I Am Lost Option
    
    func showOptionsActionSheet(){
        let optionMenu = UIAlertController(title: nil, message: "Choose an option", preferredStyle: .actionSheet)
        
        let showCrowdAction = UIAlertAction(title: "Show other players", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showRA63BusTopMarker()
            self.showExchangeBicycleParkMarker()
            self.exMapView.setCenter(CIRCLE_BUS_STOP_RA63_CHAIRS.hiddenMarkerCord, zoomLevel: 17, animated: true)
        })
        
        let lostAction = UIAlertAction(title: "I'm lost", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let alert = UIAlertController(title: "I'm lost", message: "Please enter the address of the location you want to go in the below text field. You'll be guided to that location.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField(configurationHandler: { (textField) in
                
            })
            alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
                if let address = alert.textFields![0].text{
                    let directionsURL = String(format:"http://maps.apple.com/?saddr=Current%%20Location&daddr=%@", address)
                    if let url = URL(string: directionsURL) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        })
        
        let takeMeBackAction = UIAlertAction(title: "Take me back", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if let startLocation = self.startLocation{
                let directionsURL = String(format:"http://maps.apple.com/?saddr=Current%%20Location&daddr=%f,%f", startLocation.coordinate.latitude, startLocation.coordinate.longitude)
                if let url = URL(string: directionsURL) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(showCrowdAction)
        optionMenu.addAction(lostAction)
        optionMenu.addAction(takeMeBackAction)
        
        optionMenu.addAction(cancelAction)
        present(optionMenu, animated: true, completion: nil)
    }
}
