import UIKit
import Combine

private enum Constants {
    static let titleFontSize = CGFloat(30)
    static let regularFontSize = CGFloat(18)
}

final class DiscoveryCardView: UIView, Insetable {
    
    private var cancellable = Set<AnyCancellable>()
    
    private var mapView:MKMapView!
    private var titleLabel: UILabel!
    private var cliqsLabel: UILabel!
    private var storefrontLabel: UILabel!
    private var labelStack: UIStackView!
    
    private var viewModel: DiscoveryCardViewModel!
    
    override private init(frame: CGRect){
        super.init(frame: frame)
        overrideUserInterfaceStyle = .dark
        initiliazeViews()
        addConstraint()
    }
    
    func setup(with viewmodel: DiscoveryCardViewModel){
        self.viewModel = viewmodel
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bind(){
        setupMap()
        viewModel.$proximalCliqs.sink { [weak self] cliqs in
            guard let self = self  else { return }
            self.mapView.removeAnnotations(self.mapView.annotations)
            let annotations = cliqs.map{ cliq -> IdentifiableAnnotation in
                let annotation = IdentifiableAnnotation()
                annotation.coordinate = cliq.coordinate
                annotation.title = cliq.name
                annotation.identifier = cliq.id
                return annotation
            }
            self.mapView.addAnnotations(annotations)
        }.store(in: &cancellable)
    }
    
    private func setupMap(){
        mapView.delegate = self
        viewModel.$coordinate.sink { [weak self] coordinate in
            guard let self = self, let coordinate = coordinate else { return }
            let span  = MKCoordinateSpan(latitudeDelta: 0.10, longitudeDelta: 0.10)
            let region = MKCoordinateRegion(center:coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }.store(in: &cancellable)
    }

}

extension DiscoveryCardView {
    private func initiliazeViews(){
        backgroundColor = .charcoal
        mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = .makeLabel(font: .systemFont(ofSize: Constants.titleFontSize, weight: .bold), textColor: .white)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cliqsLabel = .makeLabel(font: .systemFont(ofSize: 16, weight: .regular), textColor: .white)
        storefrontLabel = .makeLabel(font: .systemFont(ofSize: Constants.regularFontSize, weight: .regular), textColor: .white)
        labelStack = .stack(views: [cliqsLabel, storefrontLabel], axis: .vertical, alignment: .leading, distribution: .fillEqually, spacing: verticalInset)
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mapView)
    }
    
    private func addConstraint(){
        mapView.pinToSuperview()
        titleLabel.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.top == topAnchor + verticalInset
        }
        
        labelStack.layout{
            $0.leading == leadingAnchor + horizontalInset
            $0.bottom == bottomAnchor - verticalInset
        }
        
    }
    
    
}


extension DiscoveryCardView: MKMapViewDelegate{


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
    
    func actionForCallout(_ id:String){
        //Navigate after icon selected
    }
    
}
