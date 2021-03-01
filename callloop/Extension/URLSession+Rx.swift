//
//  URLSession+Rx.swift
//  callloop
//
//  Created by Su on 2021/2/25.
//  Copyright © 2021 watts. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper


public enum RxURLSessionError: Error {
	case unknown
	case invalidResponse(response: URLResponse)
	case requestFailed(response: HTTPURLResponse, data: Data?)
	case deserializationFailed
}

extension ObservableType where Element == (HTTPURLResponse, Data) {
	func save() -> Observable<Element> {
		return self.do(onNext: { (response, data) in
			if let url = response.url?.absoluteString, 200 ..< 300 ~= response.statusCode {
				
			}
		})
	}
}


extension Reactive where Base: URLSession {
	
	func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
		return Observable.create { observer in
			// content goes here
			
			let task = self.base.dataTask(with: request) { (data, response, error) in
				guard let response = response, let data = data else {
					observer.on(.error(error ?? RxURLSessionError.unknown))
					return
				}
				
				guard let httpResponse = response as? HTTPURLResponse else {
					observer.on(.error(RxURLSessionError.invalidResponse(response: response)))
					return
				}
				observer.onNext((httpResponse, data))
				observer.on(.completed)
			}
			task.resume()
			
			return Disposables.create(with: task.cancel)
		}
	}
	
	func data(request: URLRequest) -> Observable<Data> {
		
		return response(request: request).save().map { (response, data) -> Data in
			if 200 ..< 300 ~= response.statusCode {
				return data
			} else {
				throw RxURLSessionError.requestFailed(response: response, data: data)
			}
		}
	}
	
	func json(request: URLRequest) -> Observable<[String: Any]?> {
		return data(request: request).map { d in
			return try JSONSerialization.jsonObject(with: d, options: []) as? [String: Any]
		}
	}
	
	func model<Model: Mappable>(request: URLRequest, type: Model.Type) -> Observable<Model?> {
		return data(request: request).map { d in
			return Model(JSONString: String(data: d, encoding: .utf8) ?? "")
		}
	}
	
}
