//
//  LocationManager.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 22.11.2021.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {

	static let instance = LocationManager()
	let locationManager = CLLocationManager()
	let location = PublishSubject<CLLocation?>()


	// MARK: - Initialisers

	private override init() {
		super.init()
		configureLocationManager()
	}

	// MARK: - Public Methods

	func startUpdatingLocation() {
		locationManager.startUpdatingLocation()
	}

	func stopUpdatingLocation() {
		locationManager.stopUpdatingLocation()
	}

	func requestLocation() {
		locationManager.requestLocation()
	}

	// MARK: - Private Methods

	private func configureLocationManager() {
		locationManager.delegate = self
		locationManager.allowsBackgroundLocationUpdates = true
		locationManager.pausesLocationUpdatesAutomatically = false
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
		locationManager.startMonitoringSignificantLocationChanges()
		locationManager.requestAlwaysAuthorization()
	}

}

extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.location.onNext(locations.last)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}


