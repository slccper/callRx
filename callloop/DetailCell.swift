//
//  DetailCell.swift
//  callloop
//
//  Created by Su on 2021/2/28.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation
import UIKit

class DetailCell: UITableViewCell {
	
	fileprivate let titleLb = UILabel()
	fileprivate let detailLb = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		initView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func initView() {
		titleLb.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
		titleLb.font = UIFont.systemFont(ofSize: 14)
		detailLb.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		detailLb.font = UIFont.systemFont(ofSize: 14)
		detailLb.textAlignment = .right
		
		self.contentView.addSubview(self.titleLb)
		self.contentView.addSubview(self.detailLb)
		
		self.titleLb.snp.makeConstraints { (make) in
			make.leading.equalTo(12)
			make.top.equalTo(12)
			make.width.greaterThanOrEqualTo(80)
		}
		self.detailLb.snp.makeConstraints { (make) in
			make.top.bottom.equalTo(0)
			make.trailing.equalTo(-12)
			make.leading.greaterThanOrEqualTo(self.titleLb.snp.trailing).offset(8)
		}
	}
	
	open func set(title: String, detail: String) {
		self.titleLb.text = title
		self.detailLb.text = detail
	}
}
