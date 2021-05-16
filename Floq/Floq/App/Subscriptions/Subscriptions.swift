//
//  Notifications.swift
//  QuotesMaker
//
//  Created by Shadrach Mensah on 15/03/2019.
//  Copyright © 2019 Shadrach Mensah. All rights reserved.
//

import UIKit


class Subscription{
    
    enum Name:String {
        
        case invalidatePhotos,invalidateCliq,geoPointUpdated,photoFlagged,reloadPhotos,newHighlight, cmt_photo_notify, cliqHighlight, clearSelection, cellShakeAnim
    }

    private static let _main = Subscription()
    
    static var main:Subscription{
        return _main
    }
    
    
    func post(suscription name:Name, object:Any?){
        if let object = object{
            NotificationCenter.default.post(name: NSNotification.Name(name.rawValue), object: nil,userInfo:[.info:object])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(name.rawValue), object: nil)
        }
    }
    
    func post(suscription name:Notification.Name, object:Any? = nil){
        if let object = object{
            NotificationCenter.default.post(name: name, object: nil,userInfo:[.info:object])
        }else{
            NotificationCenter.default.post(name: name, object: nil)
        }
    }
    
    
}


extension NSObject{
    func subscribeTo(subscription name:Subscription.Name,selector:Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(name.rawValue), object: nil)
    }
    
    func subscribeTo(subscription name:Notification.Name,selector:Selector){
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribe(){
        NotificationCenter.default.removeObserver(self)
    }
}



extension AnyHashable{
    
    static let info = "Info"
}



