//
//  File.swift
//  PlaygroundTest
//
//  Created by Mohammed Yusuf Mitha on 26/01/20.
//  Copyright © 2020 Mohammed Yusuf Mitha. All rights reserved.
//

import Foundation


import UIKit

final class DummyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (token.count == 0){
            
            if( UserDefaults.standard.string(forKey: "token") == nil ){
                
                API.callDictionaryAPI(webserviceFor: StringIdentifiers.guestUserLogin, webMethod: .get, parameters: [:]) { (error, task) in
                    if let task = task as? LoginModel{
                        token = task.access_token ?? ""
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.synchronize()
                        
                        self.gotoApp()
                    } else {
                        print("casting error")
                        return
                    }
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }
                    
                }
                loginForGuest { (done) in
                    if(done == true){
                        
                    }
                }
            } else{
                token = UserDefaults.standard.string(forKey: "token")!
                self.gotoApp()
            }
            
           
        }
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
 
    }
    
    func gotoApp(){
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "s4TabBarVC") as! s4TabBarVC
        self.navigationController?.pushViewController(destVC, animated: false)
        
    }
    
}
import SwiftUI
@available(iOS 13.0, *)
extension DummyViewController: UIViewControllerRepresentable {
    func makeUIViewController(
        context:UIViewControllerRepresentableContext<DummyViewController>
    ) -> DummyViewController {
        let vc = DummyViewController()
        // update the values of the vc, if needed
        return vc
    }
    func updateUIViewController(
        _ uiViewController: DummyViewController,
        context: UIViewControllerRepresentableContext<DummyViewController>) {}
}


@available(iOS 13.0, *)
struct DummyViewControllerPreview: PreviewProvider {
    static var previews: some View {
        DummyViewController()
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }
}

