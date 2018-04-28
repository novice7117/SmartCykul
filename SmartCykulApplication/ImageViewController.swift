//
//  ImageViewController.swift
//  SmartCykulApplication
//
//  Created by MAC BOOK on 11/04/18.
//  Copyright © 2018 Surendra. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate
{

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.scrollview.minimumZoomScale = 1.0
        self.scrollview.maximumZoomScale = 10.0
        self.scrollview.delegate = self
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageview
    }
    
}
