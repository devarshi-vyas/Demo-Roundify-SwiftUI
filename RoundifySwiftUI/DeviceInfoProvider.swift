//
//  DeviceInfoProvider.swift
//  RoundifySwiftUI
//
//  Created by Devarshi Vyas on 28/01/26.
//

import Foundation


import Foundation
import UIKit

class DeviceInfoProvider {
    
    static let shared = DeviceInfoProvider()
    
    private init() {}
    
    var deviceInfo: [String: String] {
        let make = "Apple"
        let model = UIDevice.current.model
        let os = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let platform = "Mobile"
        let appVersion = "0.0.1"
        let deviceID = DeviceUUIDManager.shared.getDeviceUUID()
        let specificModel = getDeviceModelName()
        
        return [
            "device_id": deviceID,
            "device_make": make,
            "device_model": specificModel,
            "os_version": osVersion,
            "app_version": appVersion,
            "platform": platform,
            "platform_detail": "iOS"
        ]
    }
    
    private func getDeviceModelName() -> String {
        let identifier: String = {
            #if targetEnvironment(simulator)
            return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Simulator"
            #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            return machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            #endif
        }()

        
        let deviceMap: [String: String] = [
            // iPhone 17 series
            "iPhone18,1": "iPhone 17 Pro",
            "iPhone18,2": "iPhone 17 Pro Max",
            "iPhone18,3": "iPhone 17",
            "iPhone18,4": "iPhone 17 Plus",
            "iPhone18,5": "iPhone 17 Air",

            // iPhone 16 series
            "iPhone17,1": "iPhone 16 Pro",
            "iPhone17,2": "iPhone 16 Pro Max",
            "iPhone17,3": "iPhone 16",
            "iPhone17,4": "iPhone 16 Plus",
            "iPhone17,5": "iPhone 16e",

            // iPhone 15 series
            "iPhone16,1": "iPhone 15 Pro",
            "iPhone16,2": "iPhone 15 Pro Max",
            "iPhone15,4": "iPhone 15",
            "iPhone15,5": "iPhone 15 Plus",

            // iPhone 14 series
            "iPhone15,2": "iPhone 14 Pro",
            "iPhone15,3": "iPhone 14 Pro Max",
            "iPhone14,7": "iPhone 14",
            "iPhone14,8": "iPhone 14 Plus",

            // iPhone 13 series
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,4": "iPhone 13 mini",
            "iPhone14,5": "iPhone 13",

            // iPhone 12 series
            "iPhone13,1": "iPhone 12 mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",

            // iPhone 11 series
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",

            // Older models
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            "iPhone10,1": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,4": "iPhone 8",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone9,1": "iPhone 7",
            "iPhone9,2": "iPhone 7 Plus",
            "iPhone9,3": "iPhone 7",
            "iPhone9,4": "iPhone 7 Plus",

            // SE models
            "iPhone12,8": "iPhone SE (2nd Gen)",
            "iPhone14,6": "iPhone SE (3rd Gen)",

            // Simulators
            "i386": "Simulator",
            "x86_64": "Simulator",
            "arm64": "Simulator"
        ]
        
        
        let readableName = deviceMap[identifier] ?? identifier

        #if targetEnvironment(simulator)
        return "\(readableName) (Simulator)"
        #else
        return readableName
        #endif
    }
}

