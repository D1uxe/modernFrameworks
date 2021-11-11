//
//  ViewController.swift
//  ModernFrameworks
//
//  Created by MacBook Pro on 06.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

final class MapViewController: UIViewController {

	// MARK: - Private Properties

	private var coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
	private var marker: GMSMarker?
	private var locationManager: CLLocationManager?
	private var route: GMSPolyline?
	private var routePath: GMSMutablePath?
	private var path: Path = Path()
	private var isTracking: Bool = false

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
		isTracking.toggle()

		switch isTracking {
		case true:
			route?.map = nil
			route = GMSPolyline()
			routePath = GMSMutablePath()
			route?.map = mapView
			locationManager?.startUpdatingLocation()
		case false:
			stopUpdateAndSaveLocation()
		}
	}

	@IBAction func currentLocation(_ sender: Any) {
		locationManager?.requestLocation()
	}

	@IBAction func showPrevTrack(_ sender: Any) {
		if isTracking {
			showAlert(title: "Остановка отслеживания", message: "Идет отслеживание. Вы хотите остановить?")
		} else {
			drawPreviousTrack()
		}
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

	private func stopUpdateAndSaveLocation() {
		locationManager?.stopUpdatingLocation() // Почему после этой команды отслеживание не останавливается полностью? А как бы карта продолжает время от времени показывать позицию(срабатывает сам по себе делегат didUpdateLocations)
		let realm = try! Realm()
		try! realm.write {
			realm.add(path, update: .all)
		}
		path = Path()
	}

	private func drawPreviousTrack() {
		let realm = try! Realm()
		guard let path = realm.object(ofType: Path.self, forPrimaryKey: 0) else { return }

		route?.map = nil
		route = GMSPolyline()
		routePath = GMSMutablePath()
		route?.map = mapView
		path.coordinates.forEach { routePath?.add($0.coordinate) }
		route?.path = routePath
		let bounds = GMSCoordinateBounds(path: routePath!)
		self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
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

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		routePath?.add(location.coordinate)
		path.coordinates.append(Location(coordinate: location.coordinate))
		route?.path = routePath
		mapView.animate(toLocation: location.coordinate)
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}

}

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

	override class func primaryKey() -> String? {
		"id"
	}
}


extension MapViewController {

	func showAlert(title: String, message: String ) {

		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
			self.locationManager?.stopUpdatingLocation()
			self.isTracking.toggle()
			self.drawPreviousTrack()
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		self.present(alert, animated: true, completion: nil)

	}
}
