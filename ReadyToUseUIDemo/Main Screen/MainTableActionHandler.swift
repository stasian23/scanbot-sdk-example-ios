//
//  MainTableActionHandler.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class MainTableActionHandler: NSObject {
    
    let presenter: UIViewController
    
    private(set) var scannedDocument = SBSDKUIDocument()
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }

    private func guardLicense(_ block: () -> ()) {
        if ScanbotSDK.isLicenseValid() {
            block()
        } else {
            self.showLicenseAlert()
        }
    }
    
    private func showLicenseAlert() {
        let alert = UIAlertController(title: "Demo expired",
                                      message: "The demo app will terminate because of the missing license key. Get your free 30-day license today!",
                                      preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close App", style: .default) { (_) in
            objc_terminate()
        }
        
        let getLicenseAction = UIAlertAction(title: "Get License", style: .cancel) { (_) in
            let url = URL(string: "https://scanbot.io/sdk/")!
            UIApplication.shared.open(url, options: [:], completionHandler: { (_) in
                objc_terminate()
            })
        }
        
        alert.addAction(closeAction)
        alert.addAction(getLicenseAction)
        alert.actions.forEach { (action) in
            action.setValue(UIColor.black, forKey: "titleTextColor")
        }
        
        self.presenter.present(alert, animated: true, completion: nil)
    }
    
    func showDocumentScanning() {
        self.guardLicense {
            UsecaseScanDocument(document: self.scannedDocument).start(presenter: self.presenter)
        }
    }
    
    func showQRCodeScanning() {
        self.guardLicense {
            UsecaseScanQRCode().start(presenter: self.presenter)
        }
    }
    
    func showBarcodeScanning() {
        self.guardLicense {
            UsecaseScanBarcode().start(presenter: self.presenter)
        }
    }
    
    func showMRZScanning() {
        self.guardLicense {
            UsecaseScanMRZ().start(presenter: self.presenter)
        }
    }
    
    func showImportImages() {
        self.guardLicense {
            UsecaseBrowseDocumentPages(document: self.scannedDocument,
                                       mode: .importing).start(presenter: self.presenter)
        }
    }
    
    func showAllImages() {
        self.guardLicense {
            UsecaseBrowseDocumentPages(document: self.scannedDocument,
                                       mode: .viewing).start(presenter: self.presenter)
        }
    }
}
