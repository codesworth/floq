//
//  CliqMarkerView.swift
//  Floq
//
//  Created by OZE-Shadrach on 7/11/20.
//  Copyright © 2020 Arun Nagarajan. All rights reserved.
//

import MapKit
import Firebase


class IdentifiableAnnotation:MKPointAnnotation{
    
     var identifier:String = ""
    

}



class CliqMarkerView: MKAnnotationView {
    
    

    lazy var centerView:UIView = {
        let view = UIView()
        view.backgroundColor = .pear
        view.dropCorner(5)
        return view
    }()
    
    lazy var boundingView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pear.withAlphaComponent(0.2)
        view.dropCorner(15)
        return view
    }()
    
    lazy var discloure:UIButton = {
        let image = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        image.setImage(UIImage(named: "chevron_right"), for: .normal)
        image.tintColor = .pear
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    var identifier:String = ""

    var actionForTap: ((String) -> ())?

    init(annotation:IdentifiableAnnotation) {
        self.identifier = annotation.identifier
        super.init(annotation: annotation, reuseIdentifier: Self.Identifier)
        initialize()
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize(){
        backgroundColor = .clear
        rightCalloutAccessoryView = discloure
        addSubview(boundingView)
        dropShadow(1, color: .gray, 0.3,CGSize(width: 1, height: 1))
        addSubview(centerView)
        centerView.frame.size = CGSize(width: 10, height: 10)
        boundingView.frame.size = CGSize(width: 30, height: 30)
        layer.borderColor = UIColor.pear.cgColor
        layer.borderWidth = 0
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        boundingView.bounce(delay: .now(),name: "bounce")
    }
    
    @objc func tapped(){
        print("Im Tapped Im rapped")
        //actionForTap?(identifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerView.layout{
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
            $0.height |=| 10
            $0.width |=| 10
        }
        
        boundingView.layout{
            $0.centerX == centerXAnchor
            $0.centerY == centerYAnchor
            $0.height |=| 30
            $0.width |=| 30
        }
    }

        
}


