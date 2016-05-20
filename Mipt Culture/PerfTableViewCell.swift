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

    weak var tableVC: PerfTableViewController!
    
    
    var perfomamces = [Perfomance]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clearColor()
        textLabel?.font = UIFont(name: "RopaSans", size: 15)
        let selBckgView = UIView()
        selBckgView.backgroundColor = .clearColor()
        selectedBackgroundView = selBckgView
        
        
        let stickImage0 = UIImageView(image: UIImage(named: "stick"))
        let moreStackView = UIStackView(arrangedSubviews: [stickImage0, moreButton])
        moreStackView.spacing = 10
        moreButton.setTitle("Подробнее", forState: .Normal)
        moreButton.setTitleColor(.blackColor(), forState: .Normal)
        moreButton.setTitleColor(.grayColor(), forState: .Highlighted)
        moreButton.titleLabel!.font = UIFont(name: "RopaSans", size: 30)
        moreButton.addTarget(self, action: #selector(showDescription), forControlEvents: .TouchUpInside)
        moreStackView.axis = .Horizontal
        
        stackView.addArrangedSubview(moreStackView)

        let stickImage1 = UIImageView(image: UIImage(named: "stick"))
        let enrollStackView = UIStackView(arrangedSubviews: [stickImage1, enrollButton])
        enrollStackView.spacing = 10
        enrollButton.setTitle("Записаться", forState: .Normal)
        enrollButton.setTitleColor(.blackColor(), forState: .Normal)
        enrollButton.setTitleColor(.grayColor(), forState: .Highlighted)
        enrollButton.titleLabel!.font = UIFont(name: "RopaSans", size: 30)
        enrollButton.addTarget(self, action: #selector(enroll), forControlEvents: .TouchUpInside)
        enrollStackView.axis = .Horizontal
        priceLabel.font = UIFont(name: "RopaSans", size:30)
        enrollStackView.addArrangedSubview(priceLabel)

        priceLabel.snp_makeConstraints { (make) in
            make.trailing.equalTo(enrollStackView.snp_trailing)
        }
        
        
        stackView.addArrangedSubview(enrollStackView)
        
        let stickImage2 = UIImageView(image: UIImage(named: "stick"))
        let contactStackView = UIStackView(arrangedSubviews: [stickImage2, contactButton])
        contactStackView.spacing = 10
        contactButton.setTitle("Написать администратору", forState: .Normal)
        contactButton.setTitleColor(.blackColor(), forState: .Normal)
        contactButton.setTitleColor(.grayColor(), forState: .Highlighted)
        contactButton.titleLabel!.font = UIFont(name: "RopaSans", size: 27)
        contactButton.addTarget(self, action: #selector(contactVK), forControlEvents: .TouchUpInside)
        contactStackView.axis = .Horizontal
        
        
        stackView.addArrangedSubview(contactStackView)

        stackView.axis = .Vertical
        stackView.spacing = 20
        stackView.alignment = .Leading
        
        if let savedPerfs = loadPerfomances() {
            perfomamces = savedPerfs
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
