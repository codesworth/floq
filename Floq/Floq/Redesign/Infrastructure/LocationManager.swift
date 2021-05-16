//
//  LocationManager.swift
//  Floq
//
//  Created by ES-Shadrach on 16/05/2021.
//  Copyright © 2021 Arun Nagarajan. All rights reserved.
//

import Foundation


import FirebaseFirestore
import FirebaseStorage
import Combine
import CoreLocation


final public class LocationManager:NSObject{
    
    static let locationChanged = Notification.Name("LocationMangerUpdatedLocation")
    
    public let RADIUS = 0.5
    private var locationManager:CLLocationManager?
    private var currentLocation:CLLocation?
    private var isfetching = false
    var locationErrorPublisher: PassthroughSubject<AppError,Never> = .init()
    var coordinate: CLLocationCoordinate2D? { currentLocation?.coordinate }
    
    public override init() {
        super.init()
        locationManager = CLLocationManager()
        
    }
    
    func generateLocation(){
        locationManager?.startUpdatingLocation()
        
    }
    
    var refreshLocation:((CLLocation) -> Void)?

    
    enum LocationError:Error{
        case unableToFindLocation
    }
    
}



extension LocationManager:CLLocationManagerDelegate{
    
    func setupLocation(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager?.startUpdatingLocation()
            //locationManager?.startMonitoringSignificantLocationChanges()
        }else {
            locationErrorPublisher.send(.init(errorMessage: "Location service isnt enabled or available on this device."))
        }
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let userLocation = locations.first else{
            return
        }
        currentLocation = userLocation
        locationManager?.startMonitoringSignificantLocationChanges()
        Subscription.main.post(suscription: LocationManager.locationChanged)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        locationErrorPublisher.send(.init(errorMessage: error.localizedDescription))
    }
    
    
}
