//
// Created by 李学兵 on 15/11/8.
// Copyright (c) 2015 lengly. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{
    var camera: GMSCameraPosition?
    var locationManager: CLLocationManager = CLLocationManager()
    var mapView: GMSMapView?
    var path: GMSMutablePath?
    var started = false
    var distance = 0.0
    var lastLocation: CLLocation?
    var startTime = 0.0
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
                super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.distanceFilter = 1
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("locationServicesEnabled: " + String(CLLocationManager.locationServicesEnabled()))
        
        initLocationManager()
        initButton()
        
        camera = GMSCameraPosition.cameraWithLatitude(31.2, longitude: 121.5, zoom: 15)
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView!.delegate = self
        mapView!.myLocationEnabled = true
        mapView!.mapType = kGMSTypeNormal
        mapView!.accessibilityElementsHidden = false
        mapView!.settings.zoomGestures = false
        mapView!.settings.indoorPicker = false
//        mapView!.settings.myLocationButton = true
        mapView!.settings.scrollGestures = false
//        self.view = mapView
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        mapView!.frame = CGRectMake(0, 0, width, height - 200)
        self.view.addSubview(mapView!)
        
        if let mylocation = mapView!.myLocation {
            print("User's location: \(mylocation)")
        } else {
            print("User's location is unknown")
        }
    }
    
    func initButton() {
        
    }
    
    @IBAction func onActionButtonClick(sender: UIButton) {
        if (started) {
            started = false
            self.actionButton.setTitle("Start", forState: UIControlState.Normal)
            markPoint(self.locationManager, startPoint: false)
        } else {
            started = true
            self.distance = 0
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            self.actionButton.setTitle("End", forState: UIControlState.Normal)
            markPoint(self.locationManager, startPoint: true)
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        print("didUpdateLocations:  \(location.coordinate.latitude), \(location.coordinate.longitude)")
        self.mapView!.animateToLocation(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude))
        trackPath(manager)
    }
    
    func markPoint(locationManager: CLLocationManager, startPoint: Bool) {
        self.lastLocation = locationManager.location
        let location = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let marker = GMSMarker(position: location)
        if (startPoint) {
            marker.title = "Start Point"
            self.path = GMSMutablePath()
        } else {
            marker.title = "End point"
            self.path = nil
        }
        marker.infoWindowAnchor = CGPointMake(0.5, 0.5)
        marker.map = self.mapView
    }
    
    func trackPath(locationManager: CLLocationManager) {
        if (self.path == nil) {
            return
        }
        self.distance += lastLocation!.distanceFromLocation(locationManager.location!)
        self.distanceLabel.text = "Total Run Distance: " + String(format: "%.1f", arguments: [self.distance]) + "m"
        self.timeLabel.text = "Running Time: " + String(format: "%.1f", arguments: [NSDate.timeIntervalSinceReferenceDate() - self.startTime]) + "s"
        path!.addCoordinate(CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!))
        paintPath(self.path!)
        self.lastLocation = locationManager.location
    }
    
    func paintPath(path: GMSMutablePath) {
        let polyline = GMSPolyline(path: self.path)
        polyline.map = self.mapView
        polyline.strokeColor = UIColor.blueColor()
        polyline.strokeWidth = 3
    }
}
