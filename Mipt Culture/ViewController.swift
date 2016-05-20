//
//  ViewController.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import UIKit
import SnapKit
import Parse

class ViewController: UIViewController {
    
    var backgroundImageView: UIImageView!
    
    func loadBackground() {
        let backgroundImage = UIImage(named: "hare-1")
        backgroundImageView = UIImageView(image: backgroundImage)
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    override func loadView() {
        super.loadView()
        loadBackground()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(1, animations: { 
            self.backgroundImageView.alpha = 0.1
        }) { (completed: Bool) in
            Fetcher.updateSavedData()
            let vc = PerfTableViewController()
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

