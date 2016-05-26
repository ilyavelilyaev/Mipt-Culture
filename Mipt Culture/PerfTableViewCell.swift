//
//  TableViewCell.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import UIKit

class PerfTableViewCell: UITableViewCell {
    
    let stackView = UIStackView()
    let moreButton = UIButton(type: .Custom)
    let enrollButton = UIButton(type: .Custom)
    let contactButton = UIButton(type: .Custom)
    var index = Int()
    let priceLabel = UILabel()
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let verticalSpacingScaleFactor = CGFloat(0.025)
    let fontSizeScaleFactor = CGFloat(0.045)
    let secondFontSizeScaleFactor = CGFloat(0.04)
    let horizontalSpacingScaleFactor = CGFloat(0.027)
    
    weak var tableVC: PerfTableViewController!

    var perfomamces = [Perfomance]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clearColor()
        
        let selBckgView = UIView()
        selBckgView.backgroundColor = .clearColor()
        selectedBackgroundView = selBckgView
        
        let stickImage0 = UIImageView(image: UIImage(named: "stick"))
        let moreStackView = UIStackView(arrangedSubviews: [stickImage0, moreButton])
        moreStackView.spacing = horizontalSpacingScaleFactor * screenWidth
        moreButton.setTitle("Подробнее", forState: .Normal)
        moreButton.setTitleColor(.blackColor(), forState: .Normal)
        moreButton.setTitleColor(.grayColor(), forState: .Highlighted)
        moreButton.titleLabel!.font = UIFont(name: "RopaSans", size: fontSizeScaleFactor * screenHeight)
        moreButton.addTarget(self, action: #selector(showDescription), forControlEvents: .TouchUpInside)
        moreStackView.axis = .Horizontal
        
        stackView.addArrangedSubview(moreStackView)

        let stickImage1 = UIImageView(image: UIImage(named: "stick"))
        let enrollStackView = UIStackView(arrangedSubviews: [stickImage1, enrollButton])
        enrollStackView.spacing = horizontalSpacingScaleFactor * screenWidth
        enrollButton.setTitleColor(.blackColor(), forState: .Normal)
        enrollButton.setTitleColor(.grayColor(), forState: .Highlighted)
        enrollButton.titleLabel!.font = UIFont(name: "RopaSans", size: fontSizeScaleFactor * screenHeight)
        enrollButton.addTarget(self, action: #selector(enroll), forControlEvents: .TouchUpInside)
        enrollStackView.axis = .Horizontal
        
        stackView.addArrangedSubview(enrollStackView)
        
        let stickImage2 = UIImageView(image: UIImage(named: "stick"))
        let contactStackView = UIStackView(arrangedSubviews: [stickImage2, contactButton])
        contactStackView.spacing = horizontalSpacingScaleFactor * screenWidth
        contactButton.setTitle("Написать администратору", forState: .Normal)
        contactButton.setTitleColor(.blackColor(), forState: .Normal)
        contactButton.setTitleColor(.grayColor(), forState: .Highlighted)
        contactButton.titleLabel!.font = UIFont(name: "RopaSans", size: secondFontSizeScaleFactor * screenHeight)
        contactButton.addTarget(self, action: #selector(contactVK), forControlEvents: .TouchUpInside)
        contactStackView.axis = .Horizontal
        
        stackView.addArrangedSubview(contactStackView)

        stackView.axis = .Vertical
        stackView.spacing = verticalSpacingScaleFactor * screenHeight
        stackView.alignment = .Leading
        
        if let savedPerfs = loadPerfomances() {
            perfomamces = savedPerfs
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadPerfomances() -> [Perfomance]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Perfomance.ArchiveURL.path!) as? [Perfomance]
    }
    
    func showDescription() {
        tableVC.showDescription(index)
    }
    
    func contactVK()  {
        UIApplication.sharedApplication().openURL(perfomamces[index].adminURL!)
    }
    
    func enroll() {
        UIApplication.sharedApplication().openURL(perfomamces[index].regURL!)
    }
}
