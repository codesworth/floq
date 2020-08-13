//
//  CliqMapVC.swift
//  Floq
//
//  Created by OZE-Shadrach on 7/11/20.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import UIKit

class CliqMapVC: UIViewController {
    
    private var photoEngine:CliqEngine!
    
    
    lazy var mapView:MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.showsUserLocation = true
        return map
    }()
    
    
    init(engine:CliqEngine){
        self.photoEngine = engine
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13, *){
            overrideUserInterfaceStyle = .dark
        }
        view.backgroundColor = .white
        view.addSubview(mapView)
        mapView.frame = view.frame
        mapView.delegate = self
        setupMap()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoEngine.nearbyCliqs.forEach{
            let annotation = IdentifiableAnnotation()
            annotation.coordinate = $0.location!.coordinate
            annotation.title = $0.name
            annotation.identifier = $0.id
            
            //marker.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
            mapView.addAnnotation(annotation)
            
        }
        
    }
    
    func setupMap(){
        
        if let location = applicationDelegate.currentLocation{
            let span  = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
            let region = MKCoordinateRegion(center:location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func actionForCallout(_ id:String){
        if let cliq = (photoEngine.nearbyCliqs.first{$0.id == id}), let parent = parent as? NearbyCliqsVC{
            parent.openCliqDetail(cliq)
        }
    }

}




extension CliqMapVC: MKMapViewDelegate{


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        if annotation is MKUserLocation{
            return MKAnnotationView(annotation: annotation, reuseIdentifier: "userAnnotation")
        }

        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: CliqMarkerView.Identifier){
            view.annotation = annotation
            view.canShowCallout = true
            //(view as! CliqMarkerView).actionForTap = actionForCallout(_:)
            return view
        }else{
            let view = CliqMarkerView(annotation: annotation as! IdentifiableAnnotation)
            view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            view.canShowCallout = true
            //view.actionForTap = actionForCallout(_:)
            return view
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let view = view as? CliqMarkerView{
            actionForCallout(view.identifier)
        }
        view.isHidden = true
    }
    
}
