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
    let blackView = UIControl(frame: UIScreen.mainScreen().bounds)
    let underTextViewShadow = TextViewShadow()
    let textView = UITextView()

    var selectedRow = -1
    
    func loadPlaceholders() {
        placeholders.append(UIImage(named: "placeholder1")!)
        placeholders.append(UIImage(named: "placeholder2")!)
        placeholders.append(UIImage(named: "placeholder3")!)
        placeholders.append(UIImage(named: "placeholder4")!)
        placeholders.append(UIImage(named: "placeholder5")!)
        placeholders.append(UIImage(named: "placeholder6")!)
        placeholders.appendContentsOf(placeholders)
        for _ in 0...12 {
            placeholders.sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        updateData()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateData), forControlEvents: .ValueChanged)
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! PerfTableViewCell
        cell.index = indexPath.row
        cell.tableVC = self
        let placeholder = UIImageView(image:placeholders[indexPath.row % placeholders.count])
        
        cell.addSubview(placeholder)
        placeholder.snp_makeConstraints { (make) in
            make.width.equalTo(cell)
            make.height.equalTo(placeholder.snp_width).dividedBy(2)
            make.centerX.equalTo(cell)
            make.top.equalTo(cell.snp_top).inset(2)
        }
        
        placeholder.hnk_setImageFromURL(perfomances[indexPath.row].tablePicURL)
        
        if selectedRow == indexPath.row {
            let price = perfomances[indexPath.row].price
            cell.priceLabel.text = (price != 0) ?  "(цена: \(price) Р)" : "(бесплатно)"
            
            cell.addSubview(cell.stackView)
            cell.stackView.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(placeholder.snp_bottom).offset(15)
                make.left.equalTo(placeholder.snp_left).offset(20)
            })
            
        } else {
            cell.stackView.removeFromSuperview()
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedRow == indexPath.row {
            return view.bounds.width
        }
        return view.bounds.width / 2
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == selectedRow {
            selectedRow = -1
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } else if selectedRow != -1 {
            let prevPath = NSIndexPath(forRow: selectedRow, inSection: 0)
            selectedRow = -1
            tableView.reloadRowsAtIndexPaths([prevPath], withRowAnimation: .Automatic)
        } else {
            selectedRow = indexPath.row
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }

    }
    
    func showDescription(index: Int) {
        
        blackView.backgroundColor = .blackColor()
        blackView.alpha = 0.0
        view.addSubview(blackView)
        tableView.scrollEnabled = false
        view.addSubview(underTextViewShadow)
        view.addSubview(textView)
        blackView.addTarget(self, action: #selector(hideDescription), forControlEvents: .TouchUpInside)
        textView.backgroundColor = .whiteColor()
        textView.snp_makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(view.snp_width).inset(10)
        }
        underTextViewShadow.snp_makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(view.snp_width).inset(10)
        }
        
        textView.font = UIFont(name: "RopaSansLight", size: 16)
        textView.text = perfomances[index].descr
        textView.scrollEnabled = true
        textView.editable = false
        textView.selectable = false
        textView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10)

        underTextViewShadow.transform = CGAffineTransformMakeTranslation(0, -1000)
        textView.transform = CGAffineTransformMakeTranslation(0, -1000)
        UIView.animateWithDuration(0.7, animations: {
            self.blackView.alpha = 0.3
            self.textView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.underTextViewShadow.transform = CGAffineTransformMakeTranslation(0, 0)
        }) { (completed: Bool) in
            //TODO:
            //Add swipe-up gesture recognizer

        }
        
        

        
        
    }

    func hideDescription() {
        UIView.animateWithDuration(0.7, animations: {
            self.blackView.alpha = 0
            self.textView.transform = CGAffineTransformMakeTranslation(0, -1000)
            self.underTextViewShadow.transform = CGAffineTransformMakeTranslation(0, -1000)
        }) { (completed: Bool) in
            self.blackView.removeFromSuperview()
            self.textView.removeFromSuperview()
            self.textView.contentOffset = CGPointZero
            self.underTextViewShadow.removeFromSuperview()
            self.tableView.scrollEnabled = true
        }

    }
    
   
}
