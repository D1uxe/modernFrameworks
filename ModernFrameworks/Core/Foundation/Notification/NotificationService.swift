//
//  NotificationService.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 29.11.2021.
//

import Foundation
import UserNotifications

class NotificationService {

	static let shared = NotificationService()
	private let center = UNUserNotificationCenter.current()

	private init() {}

	func request() {
		center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if granted {
				print("Разрешение получено")
			} else {
				print("Разрешение не получено")
			}
		}
	}

	func checkForAuth(completion: @escaping (UNAuthorizationStatus) -> Void) {
		center.getNotificationSettings { completion($0.authorizationStatus) }
	}

	func sendNotificationRequest() {
		 let content = makeNotificationContent()
		let trigger = makeIntervalNotificationTrigger()
		let request = UNNotificationRequest(identifier: "alarms", content: content, trigger: trigger)

		  center.add(request) { error in

			  if let error = error {
				  print(error.localizedDescription)
			  }
		}
	}

	func makeNotificationContent() -> UNNotificationContent {
		  let content = UNMutableNotificationContent()
		  content.title = "Мы соскучились"
		  content.subtitle = "..."
		  content.body = "Попользуйся картами, пожалуйста"
		  content.badge = 1
		  return content
	  }


	func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
		   return UNTimeIntervalNotificationTrigger(
			   timeInterval: 10,
			   repeats: false
		   )
	   }

}
