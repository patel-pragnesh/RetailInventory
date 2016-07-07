//
//  AppDelegate.swift
//  RetailInventoryToSwift
//
//  Created by Anashkin, Evgeny on 06.06.16.
//  Copyright © 2016 Anashkin, Evgeny. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord
import SocketIOClientSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        MagicalRecord.setupCoreDataStackWithStoreNamed(MyConstant.dataBaseName)
        
        UINavigationBar.setDefaultStyles()
        SocketClient.initSocket()
        SocketClient.connect()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        SocketClient.disconnect()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        SocketClient.connect()
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

