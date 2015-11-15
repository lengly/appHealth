//
// Created by 李学兵 on 15/11/8.
// Copyright (c) 2015 lengly. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera = GMSCameraPosition.cameraWithLatitude(31.2,
            longitude: 121.5, zoom: 15)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.mapType = kGMSTypeNormal
        mapView.accessibilityElementsHidden = false
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        self.view = mapView
        
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(31.2, 121.5)
//        marker.title = "Shanghai"
//        marker.snippet = "China"
//        marker.map = mapView
    }
}
