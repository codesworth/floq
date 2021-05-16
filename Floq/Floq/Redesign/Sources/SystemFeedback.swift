//
//  SystemFeedback.swift
//
//  Created by Codesworth on 5/14/20.
//  Copyright © 2020 Shadrach. All rights reserved.
//

import UIKit
import AVFoundation


public enum ImpactFeedback {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case soft
    
    case rigid
    case selection
    case oldSchool
    case none
    
    public func vibrate() {
        switch self {
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            
        case .rigid:
            
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        case.none:break
        }
    }
}
