//
//  ViewController.swift
//  GoogleMapCalloutViewSwiftDemo
//
//  Created by polidog on 2015/08/27.
//  Copyright (c) 2015年 polidog. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GMSMapViewDelegate {
    
    var calloutView:SMCalloutView!
    var mapView:GMSMapView!
    var emptyCalloutView:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calloutView = SMCalloutView()
        
        // infoWindow用のボタン
        var button = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        button.addTarget(self, action: "calloutAccessoryButtonTapped", forControlEvents: .TouchUpInside)
        
        
        var cameraPosition = GMSCameraPosition.cameraWithLatitude(48.856132, longitude:2.339004, zoom: 12.0)
        
        mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: cameraPosition)

        mapView.delegate = self
        
        self.mapView.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        
        
        self.view.addSubview(mapView)
        
        emptyCalloutView = UIView(frame:CGRectZero)
        
        addMarkersToMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func addMarkersToMap() {
        let markerInfos = [
            [
                "TitleKey": "Eiffel Tower",
                "InfoKey": "A wrought-iron structure erected in Paris in 1889. With a height of 984 feet (300 m), it was the tallest man-made structure for many years.",
                "LatitudeKey": 48.8584,
                "LongitudeKey": 2.2946
            ],
            [
                "TitleKey": "Centre Georges Pompidou",
                "InfoKey": "Centre Georges Pompidou is a complex in the Beaubourg area of the 4th arrondissement of Paris. It was designed in the style of high-tech architecture.",
                "LatitudeKey": 48.8607,
                "LongitudeKey": 2.3524
        
            ],
            [
                "TitleKey": "The Louvre",
                "InfoKey": "The principal museum and art gallery of France, in Paris.",
                "LatitudeKey": 48.8609,
                "LongitudeKey": 2.3363
            ],
            [
                "TitleKey": "Arc de Triomphe",
                "InfoKey": "A ceremonial arch standing at the top of the Champs Élysées in Paris.",
                "LatitudeKey": 48.8738,
                "LongitudeKey": 2.2950
            ],
            [
                "TitleKey": "Notre Dame",
                "InfoKey": "A Gothic cathedral in Paris, dedicated to the Virgin Mary, built between 1163 and 1250.",
                "LatitudeKey": 48.8530,
                "LongitudeKey": 2.3498
        
            ]
        ]
        
        let pinImage = UIImage(named: "Pin")
        
        for markerInfo in markerInfos {
            var lat = markerInfo["LatitudeKey"] as! CLLocationDegrees
            var lng = markerInfo["LongitudeKey"] as! CLLocationDegrees
            
            var position = CLLocationCoordinate2DMake(lat,lng)
            var marker = GMSMarker(position: position)
            
            marker.title = markerInfo["TitleKey"] as! String
            marker.icon = pinImage
            marker.userData = markerInfo
            
            marker.infoWindowAnchor = CGPointMake(0.5, 0.25);
            marker.groundAnchor = CGPointMake(0.5, 1.0)
            
            marker.map = self.mapView
            
        }
        
    }
    


    func calloutAccessoryButtonTapped(sender:UIButton) {
        var marker = mapView.selectedMarker
        
        println(marker.userData)
        // ここはあとで書く
        
    }
    
    
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        
        let anchor = marker.position
        let point = mapView.projection.pointForCoordinate(anchor)
        
        calloutView.title = marker.title
        
        calloutView.calloutOffset = CGPointMake(0, -10.0)
        
        calloutView.hidden = false
        
        var calloutRect = CGRectZero
        calloutRect.origin = point
        calloutRect.size = CGSizeZero
        
        calloutView.presentCalloutFromRect(calloutRect, inView: mapView, constrainedToView: mapView, animated: true)
        
        return emptyCalloutView
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        if mapView.selectedMarker != nil && calloutView.hidden {
            let anchor = mapView.selectedMarker.position
            let arrowPt = calloutView.backgroundView.arrowPoint
            
            var pt = mapView.projection.pointForCoordinate(anchor)
            pt.x -= arrowPt.x
            pt.y -= arrowPt.y + 50.0
            
            calloutView.frame = CGRect(origin: pt, size: calloutView.frame.size)
        } else {
            calloutView.hidden = true
        }
    }
    
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate:CLLocationCoordinate2D) {
        self.calloutView.hidden = true
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        mapView.selectedMarker = marker
        return true
    }

}

