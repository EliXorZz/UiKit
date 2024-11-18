//
//  DocumentViewController.swift
//  Document App
//
//  Created by Dylan BATTIG on 11/18/24.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageName {
            imageView.image = UIImage(named: imageName)
        }
    }
}
