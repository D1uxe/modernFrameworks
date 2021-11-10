//
//  ViewController.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 06.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

final class MapViewController: UIViewController {

	// MARK: - Private Properties

	private var coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
	private var marker: GMSMarker?
	private var locationManager: CLLocationManager?
	private var route: GMSPolyline?
	private var routePath: GMSMutablePath?

	// MARK: - IBOutlets

	@IBOutlet weak var mapView: GMSMapView!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		configureMap()
		configureLocationManager()
	}

	// MARK: - IBAction

	@IBAction func updateLocation(_ sender: Any) {
		route?.map = nil
		route = GMSPolyline()
		routePath = GMSMutablePath()
		route?.map = mapView
		locationManager?.startUpdatingLocation()
	}

	@IBAction func currentLocation(_ sender: Any) {
		locationManager?.requestLocation()
	}

	// MARK: - Private Methods

	private func configureMap() {
		mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
	}

	private func configureLocationManager() {
		locationManager = CLLocationManager()
		locationManager?.delegate = self

		locationManager?.allowsBackgroundLocationUpdates = true
		locationManager?.pausesLocationUpdatesAutomatically = false
		locationManager?.startMonitoringSignificantLocationChanges()
		locationManager?.requestAlwaysAuthorization()
		locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
	}

	/*
	private func addMarker(position: CLLocationCoordinate2D) {
		marker = GMSMarker(position: position)
		marker?.icon = GMSMarker.markerImage(with: .systemGreen)
		marker?.title = "Вы здесь..."
		marker?.snippet = "..."
		marker?.map = mapView
	}

	func removeMarker() {
		marker?.map = nil
		marker = nil
	}
	*/
}

extension MapViewController: CLLocationManagerDelegate {

//	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		let currentCoordinate = locations[0].coordinate
//		mapView.animate(toLocation: currentCoordinate)
//		addMarker(position: currentCoordinate)
//	   }
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		routePath?.add(location.coordinate)
		route?.path = routePath
		mapView.animate(toLocation: location.coordinate)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}

}
