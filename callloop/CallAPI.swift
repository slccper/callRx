//
//  CallAPI.swift
//  callloop
//
//  Created by Su on 2021/2/25.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation
import RxSwift

class CallAPI {
	class func call(api: String) -> Observable<[String: Any]?> {
		guard let url = URL(string: api) else {
			return Observable.create { (data) -> Disposable in
				data.onNext(nil)
				data.onCompleted()
				return Disposables.create()
			}
		}
		let request = URLRequest(url: url)
		return URLSession.shared.rx.json(request: request)
	}
}
