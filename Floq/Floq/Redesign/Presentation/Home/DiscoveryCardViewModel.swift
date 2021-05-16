import Foundation
import Combine

class DiscoveryCardViewModel: NSObject {
    
    private var datasource: ProximalCliqRemoteDataSource
    @Published var coordinate:CLLocationCoordinate2D?
    private var mapper = ProximalCliqModelMapper()
    @Published var proximalCliqs: Set<ProximalCliq> = []
    
    
    init(datasource:ProximalCliqRemoteDataSource, coordinate: CLLocationCoordinate2D?) {
        self.datasource = datasource
        self.coordinate = coordinate
        super.init()
        listenForCliqs()
        subscribeTo(subscription: LocationManager.locationChanged, selector: #selector(listentForLocationUpdates(_:)))
    }
    
    private func listenForCliqs(){
        datasource.onDocumentEntered = { [weak self] cliq in
            self?.update(cliq: cliq)
        }
        datasource.onDocumentExit  = { [weak self] id in
            self?.update(id: id)
        }
        guard let coordinate = coordinate else { return }
        datasource.listenForCliqsAt(geopoint: .init(coordinate: coordinate))
    }
    
    func update(location coordinate:CLLocationCoordinate2D){
        self.coordinate = coordinate
        listenForCliqs()
    }
    
    private func update(cliq: ProximalCliqDataModel){
        let cliq = mapper.map(model: cliq)
        proximalCliqs.update(with: cliq)
    }
    
    private func update(id: String){
        guard let member = (proximalCliqs.first{$0.id == id}) else { return }
        proximalCliqs.remove(member)
    }
    
    @objc private func listentForLocationUpdates(_ notification: Notification){
        coordinate = appDiContainer.locationManager.coordinate
        Logger.debug("Location Updated at \(Date().toStringwith(.time))", domain: DiscoveryCardViewModel.Identifier)
    }
    
}
