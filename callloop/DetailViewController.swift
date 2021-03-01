//
//  DetailViewController.swift
//  callloop
//
//  Created by Su on 2021/3/1.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UITableViewController {
	
	init(item: [String: Any]) {
		super.init(nibName: nil, bundle: nil)
		self.dataSource = item.map { ($0.key, $0.value as? String ?? "") }
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate var dataSource: [(String, String)] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func loadView() {
		super.loadView()
		
		self.tableView.register(cell: DetailCell.self)
		self.tableView.rowHeight = 44
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.white
		self.title = "Detail"
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusable(cell: DetailCell.self)
		if indexPath.row < dataSource.count {
			let item = dataSource[indexPath.row]
			cell.set(title: item.0, detail: item.1)
		}
		return cell
	}
}
