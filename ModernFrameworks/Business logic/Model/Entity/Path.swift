//
//  Path.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 15.11.2021.
//

import Foundation
import CoreLocation
import RealmSwift

class Location: Object {
	@Persisted var latitude = 0.0
	@Persisted var longitude = 0.0

	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}

	convenience init(coordinate: CLLocationCoordinate2D) {
		self.init()
		latitude = coordinate.latitude
		longitude = coordinate.longitude
	}
}

class Path: Object {
	@Persisted var id = 0
	@Persisted var coordinates = List<Location>()

	override class func primaryKey() -> String? {
		"id"
	}

	/* Если объект Realm создавать внутри, карты почему-то не загружаются...
	Просто белый экран..

	private let myRealm = try! Realm()

	func write() {
			try! myRealm.write {
				myRealm.add(self, update: .all)
			}
		}

		func read() -> Results<Path> {
			myRealm.objects(Path.self)
		}
	*/
}
