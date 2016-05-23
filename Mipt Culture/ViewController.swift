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
    let vc = PerfTableViewController()
    let problemLabel = UILabel()

    func loadBackground() {
        let backgroundImage = UIImage(named: "hare-1")
        
        backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .ScaleAspectFit

        view.addSubview(backgroundImageView)
    
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
    }
    
    override func loadView() {
        super.loadView()
        loadBackground()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showInternetConnectionFail), name: "connectionFailed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(internetConnectionRestored), name: "connectionRestored", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showNoPerfomances), name: "noPerfomances", object: nil)
    }
    
    func showInternetConnectionFail() {
        showSadHare()
        problemLabel.text = "Проблемы с соединением"
    }
    
    func internetConnectionRestored() {
        let backgroundImage = UIImage(named: "hare-1")
        backgroundImageView.image = backgroundImage
        problemLabel.removeFromSuperview()
    }
    
    func showNoPerfomances() {
        showSadHare()
        problemLabel.text = "Нет ближайших спектаклей"
    }
    
    func showSadHare() {
        backgroundImageView.image = UIImage(named: "sad-hare")
        
        view.addSubview(problemLabel)
        problemLabel.snp_makeConstraints { (make) in
            make.center.equalTo(view)
        }
        problemLabel.font = UIFont(name: "RopaSansThin", size: 20)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(1, animations: { 
            self.backgroundImageView.alpha = 0.1
        }) { (completed: Bool) in
            self.addChildViewController(self.vc)
            self.view.addSubview(self.vc.view)
            //Fetcher.updateSavedData()
        }
    }
    
}

