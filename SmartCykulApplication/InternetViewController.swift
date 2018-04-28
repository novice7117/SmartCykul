//
//  InternetViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 12/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class InternetViewController: UIViewController,UIWebViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        webview.delegate = self
        let myURL = URL(string: "http://www.cykul.com")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        webview.loadRequest(myURLRequest)

    }
    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activity.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activity.isHidden = true
        activity.stopAnimating()
    }

}
