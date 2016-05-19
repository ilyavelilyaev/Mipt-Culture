//
//  PerfTableViewController.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import UIKit
import Haneke

class PerfTableViewController: UITableViewController {
    var perfomances = [Perfomance]()
    var placeholders = [UIImage]()
    
    func loadPlaceholders() {
        placeholders.append(UIImage(named: "placeholder1")!)
        placeholders.append(UIImage(named: "placeholder2")!)
        placeholders.append(UIImage(named: "placeholder3")!)
        placeholders.append(UIImage(named: "placeholder4")!)
        placeholders.append(UIImage(named: "placeholder5")!)
        placeholders.append(UIImage(named: "placeholder6")!)
        placeholders.append(UIImage(named: "placeholder7")!)
        placeholders.appendContentsOf(placeholders)
        for _ in 0...14 {
            placeholders.sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        update()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateData), forControlEvents: .ValueChanged)
        
        title = "Афиша"
        
        tableView.separatorStyle = .None
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(update), name: "updatedPerfomances", object: nil)
        
        loadPlaceholders()
    }
    
    func loadPerfomances() -> [Perfomance]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Perfomance.ArchiveURL.path!) as? [Perfomance]
    }
    
    func update() {
        if let savedPerfomances = loadPerfomances() {
            perfomances = savedPerfomances
        }
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func updateData() {
        Fetcher.updateSavedData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(PerfTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perfomances.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        let placeholder = UIImageView(image:placeholders[indexPath.row % 14])
        
        cell.addSubview(placeholder)
        placeholder.snp_makeConstraints { (make) in
            make.edges.equalTo(cell).inset(5)
        }
        
        placeholder.hnk_setImageFromURL(perfomances[indexPath.row].tablePicURL)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.bounds.width / 2
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! PerfTableViewCell
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        UIView.animateWithDuration(1) { 
            
        }
        
        let vc = DetailViewController()
        let nvc = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nvc, animated: true, completion: nil)
    }
   
}
