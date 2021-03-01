//
//  StorageTool.swift
//  callloop
//
//  Created by Su on 2021/2/27.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation
import RxSwift

class StorageTool: NSObject {
	
    static let sharedInstance = StorageTool()
	
	var currentList: [[String: Any]]? {
		didSet {
			if let datas = currentList {
				signal.onNext(datas)
			}
		}
	}
	
	let signal = PublishSubject<[[String: Any]]>()
	
	
	fileprivate var disposeBag = DisposeBag()
	fileprivate let filePath: String = {
		let pathArray = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map { $0.path }
		let path = pathArray[0]
		//获取文件的完整路径
		let filePatch = URL(fileURLWithPath: path).appendingPathComponent("PropertyList.plist").path
		return filePatch
	}()
	
	override init() {
		super.init()
		
		configStorage()
		
		signal.subscribe { (datas) in
			let list = datas.element as NSArray?
			list?.write(toFile: self.filePath, atomically: true)
		}.disposed(by: disposeBag)
	}
}

extension StorageTool {
	
     func configStorage() {
		if FileManager.default.fileExists(atPath: self.filePath), let xml = FileManager.default.contents(atPath: self.filePath) {
			let sandBoxDataList = (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [[String : Any]]
			self.currentList = sandBoxDataList ?? []
		} else {
			self.currentList = []
		}
    }

	static func add(data: [String : Any]) {
		sharedInstance.currentList?.append(data)
    }
}
