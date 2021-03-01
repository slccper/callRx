//
//  ViewController.swift
//  callloop
//
//  Created by Su on 2021/2/24.
//  Copyright © 2021 watts. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class ViewController: UITableViewController {
	
	fileprivate let showLb = UITextView()
	fileprivate var disposable = DisposeBag()
	
	fileprivate var dataSource: [(String, Any)] = [] {
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
		// Do any additional setup after loading the view.
		startTimer()
		self.view.backgroundColor = UIColor.white
		self.dataSource = (StorageTool.sharedInstance.currentList?.last?["response"] as? [String: Any])?.map { ($0.key, $0.value) } ?? []
	}

	func startTimer() {
		Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
			let url = "http://api.github.com"
			let startTime = Date().timeIntervalSince1970
			CallAPI.call(api: url).subscribe { (observe) in
				guard let datas = observe.element, let list = datas else { return }
				let dict: [String : Any] = ["time": startTime, "url": url, "response": list]
				StorageTool.sharedInstance.currentList?.append(dict)
				self.dataSource = list.map { ($0.key, $0.value) }
			}.disposed(by: self.disposable)
		}
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusable(cell: DetailCell.self)
		if indexPath.row < dataSource.count {
			let item = dataSource[indexPath.row]
			cell.set(title: item.0, detail: item.1 as? String ?? "")
		}
		return cell
	}
	
	@IBAction func historyAction(_ sender: Any) {
		self.navigationController?.pushViewController(HistoryViewController(), animated: true)
	}
}

