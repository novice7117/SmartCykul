//
//  FacebookWebCykulViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 19/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class FacebookWebCykulViewController: UIViewController,UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        web.delegate = self
        let myURL = URL(string: "https://www.facebook.com/cykul/")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        web.loadRequest(myURLRequest)

        // Do any additional setup after loading the view.
    }

    

    @IBOutlet weak var web: UIWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activity.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activity.isHidden = true
        activity.stopAnimating()
    }
}
