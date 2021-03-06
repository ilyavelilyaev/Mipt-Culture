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
    var blackView: UIControl!
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
        
        view.backgroundColor = .clearColor()
        
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
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func updateData() {
        Fetcher.updateSavedData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(PerfTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
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
            cell.enrollButton.setTitle("Записаться " + ((price != 0) ?  "(цена: \(price) Р)" : "(бесплатно)"), forState: .Normal)
            cell.addSubview(cell.stackView)
            cell.stackView.snp_makeConstraints { (make) in
                make.top.equalTo(placeholder.snp_bottom).offset(10)
                make.left.equalTo(placeholder.snp_left).offset(20)
            }
            
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
        var indexPathesToBeReloaded = [NSIndexPath]()
        
        switch selectedRow {
        case indexPath.row:
            indexPathesToBeReloaded.append(indexPath)
            selectedRow = -1
        case -1:
            indexPathesToBeReloaded.append(indexPath)
            selectedRow = indexPath.row
        default:
            indexPathesToBeReloaded.append(NSIndexPath(forRow: selectedRow, inSection: 0))
            selectedRow = indexPath.row
            indexPathesToBeReloaded.append(indexPath)
        }
        
        tableView.reloadRowsAtIndexPaths(indexPathesToBeReloaded, withRowAnimation: .Automatic)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
    
    func showDescription(index: Int) {
        tableView.scrollEnabled = false

        blackView = UIControl(frame: view.bounds)
        blackView.backgroundColor = .blackColor()
        blackView.alpha = 0.0
        blackView.addTarget(self, action: #selector(hideDescription), forControlEvents: .TouchUpInside)
        
        view.addSubview(blackView)
        view.addSubview(underTextViewShadow)
        view.addSubview(textView)
        
        
        textView.snp_makeConstraints { (make) in
            make.center.equalTo(blackView)
            make.width.height.equalTo(blackView.snp_width).inset(10)
        }
        underTextViewShadow.snp_makeConstraints { $0.edges.equalTo(textView) }
        
        textView.backgroundColor = .whiteColor()
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
        })
    }

    func hideDescription() {
        UIView.animateWithDuration(0.7, animations: {
            self.blackView.alpha = 0
            self.textView.transform = CGAffineTransformMakeTranslation(0, -1000)
            self.underTextViewShadow.transform = CGAffineTransformMakeTranslation(0, -1000)
        }) { (completed: Bool) in
            self.blackView.removeFromSuperview()
            self.textView.removeFromSuperview()
            self.underTextViewShadow.removeFromSuperview()
            self.tableView.scrollEnabled = true
            self.textView.contentOffset = CGPointZero //needed to scroll back to top of desctiption
        }
    }
}
