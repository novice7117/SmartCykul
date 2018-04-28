//
//  InstructionViewController.swift
//  SmartCykul
//
//  Created by Cykul Cykul on 29/01/18.
//  Copyright © 2018 Cykul Cykul. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var barBtn: UIBarButtonItem!
    
    @IBOutlet weak var Scrollview: UIScrollView!
    
    @IBOutlet weak var down: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.Scrollview.minimumZoomScale = 1.0
        self.Scrollview.maximumZoomScale = 10.0
        
        if revealViewController != nil
            
        {
            
            barBtn.target = revealViewController()
            
            barBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
}
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return down
    }
    
    @IBAction func homebtn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "svc") as! SlideViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
