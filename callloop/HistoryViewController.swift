//
//  HistoryViewController.swift
//  callloop
//
//  Created by Su on 2021/2/27.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class HistoryViewController: UITableViewController {
	
	fileprivate var disposeBag = DisposeBag()
	fileprivate var dataSource: [[String : Any]]? {
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
		self.title = "History"
		self.dataSource = StorageTool.sharedInstance.currentList?.reversed()
		
		StorageTool.sharedInstance.signal.subscribe { (datas) in
			self.dataSource = datas.element?.reversed();
		}.disposed(by: disposeBag)
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource?.count ?? 0
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusable(cell: DetailCell.self)
		if indexPath.row < dataSource?.count ?? 0, let item = dataSource?[indexPath.row] {
			let time = item["time"] as? TimeInterval
			cell.set(title: time?.toDate(format: "MM-dd HH:mm") ?? "", detail: item["url"] as? String ?? "")
		}
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = dataSource?[indexPath.row]["response"] as? [String: Any] ?? [:]
		self.navigationController?.pushViewController(DetailViewController(item: item), animated: true)
	}
}

extension UITableView {
	func register<T: UITableViewCell>(cell: T.Type) {
		self.register(cell, forCellReuseIdentifier: NSStringFromClass(cell))
	}
	func dequeueReusable<T: UITableViewCell>(cell: T.Type) -> T {
		return self.dequeueReusableCell(withIdentifier: NSStringFromClass(cell)) as! T
	}
}
