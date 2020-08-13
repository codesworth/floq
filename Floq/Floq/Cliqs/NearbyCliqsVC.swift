//
//  HomeVC.swift
//  Floq
//
//  Created by Mensah Shadrach on 29/12/2018.
//  Copyright © 2018 Arun Nagarajan. All rights reserved.
//

import IGListKit
import Firebase


import CoreLocation




class NearbyCliqsVC: UIViewController{

    private var isFetchingNearby = false
    private var photoEngine:CliqEngine{
        return (UIApplication.shared.delegate as! AppDelegate).mainEngine
    }
    private var locationManager:CLLocationManager!
    private var queryhandle:GFSQueryHandle?
    private  var myCliqs:Set<String>!
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    lazy var mapVC:CliqMapVC = {
        CliqMapVC(engine: photoEngine)
    }()


    convenience init(data:[FLCliqItem]) {
        self.init()
        
        //myCliqs = photoEngine.nearbyCliqs
    }

    

    lazy var collectionView:UICollectionView = {
        let col = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        col.showsVerticalScrollIndicator = false
        return col
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
          navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_loc_alternate"), style: .plain, target: self, action: #selector(switchToMap(_:)))
        button.tag = 200
        button.tintColor = .white
        let buttonTwo = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(switchToList(_:)))
        button.tag = 100
        button.tintColor = .white
        navigationItem.setRightBarButtonItems([button,buttonTwo], animated: true)
        
        collectionView.backgroundColor = .globalbackground
        performRegistrations()
        self.add(mapVC, to: view)
        mapVC.view.isHidden = true
        
        let floaty = Floaty()
        floaty.buttonColor = .clear
        floaty.buttonImage = .icon_app_rounded
        floaty.fabDelegate = self
        
        
        view.addSubview(collectionView)
        view.addSubview(floaty)

        adapter.collectionViewDelegate = self
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.reloadData(completion: nil)
    }
    
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapVC.view.frame = view.bounds
        collectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Near Me"
        App.setDomain(.Nearby)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self)
    }

    @objc func reloadData(){
        adapter.reloadData(completion: nil)
    }

    
    @objc func switchToList(_ sender:UIBarButtonItem){
        mapVC.view.isHidden = true
        collectionView.isHidden = false
    }
    
    @objc func switchToMap(_ sender:UIBarButtonItem){
        mapVC.view.isHidden = false
        collectionView.isHidden = true
        if let location = applicationDelegate.currentLocation{
            mapVC.mapView.setCenter(location.coordinate, animated: true)
        }
    }


    func openCliqDetail(_ cliq:FLCliqItem){
        self.navigationController?.pushViewController(PhotosVC(cliq: cliq, id: cliq.id), animated: true)
    }
}


extension NearbyCliqsVC: UICollectionViewDelegate, ListAdapterDataSource{

    

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {

        return photoEngine.nearbyCliqs as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PhotoSection(isHome: false, keys: .near)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return .listAdapterEmptyView(superView: self.view, info: .nocliqs_nearby)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cliq = self.photoEngine.nearbyCliqs[indexPath.section]
        openCliqDetail(cliq)

    }
    
    func performRegistrations(){
        NotificationCenter.set(observer: self, selector: #selector(reloadData), name: .cliqEntered)
        NotificationCenter.set(observer: self, selector: #selector(reloadData), name: .cliqLeft)
    }
}


extension NearbyCliqsVC:FloatyDelegate{
    
    
    func emptyFloatySelected(_ floaty: Floaty) {
        let vc = AddCliqVC()
        vc.modalPresentationStyle = . fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
