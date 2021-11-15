//
//  User.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 15.11.2021.
//

import Foundation
import RealmSwift

class BaseRealm {

	static private let myRealm = try! Realm()

	static func write<T:Object>(objects: [T]) {
		try! myRealm.write {
			myRealm.add(objects, update: .all)
		}
	}

	static func read<T: Object>(with primaryKey: Int) -> T? {
		myRealm.object(ofType: T.self, forPrimaryKey: primaryKey)
	}

	static func read<T: Object>(of type: T.Type) -> [T] {
		Array(myRealm.objects(type))

	}
}


class User: Object {

	@Persisted var id = 0
	@Persisted var login: String = ""
	@Persisted var password: String = ""

	private static var counter: Int = 0
	
	override class func primaryKey() -> String? {
		"id"
	}

	convenience init(login: String, password: String) {
		self.init()

		self.login = login
		self.password = password

		User.counter += 1
		id = User.counter
	}

}
