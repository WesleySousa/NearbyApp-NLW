//
//  HomeViewController.swift
//  NearbyApp NLW
//
//  Created by Wesley Silva on 16/12/24.
//

import Foundation
import UIKit
import MapKit

class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private var places: [Place] = []
    private var homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        self.homeView.configureTableViewDelegate(self, dataSource: self)
        defineInitialLocation()
        
        homeViewModel.fetchInitialData { [weak self] categories in
            guard let self = self else { return }
            self.homeView.updateFilterButtons(with: categories) { selectedCategory in
                self.filterPlaces(by: selectedCategory)
            }
        }

        self.addAnnotationsToMap()
        homeViewModel.didUpdatePlaces = { [weak self] in
            DispatchQueue.main.async {
                self?.places = self?.homeViewModel.places ?? []
                self?.homeView.reloadTableViewData()
                self?.addAnnotationsToMap()
            }
        }
    }
    
    private func defineInitialLocation() {
        let initialLocaltion = CLLocationCoordinate2D(latitude:-23.561187293883442,
                                                      longitude: -46.656451388116494)
        homeView.mapView.setRegion(MKCoordinateRegion(center: initialLocaltion, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
    }
    
    private func addAnnotationsToMap() {
        homeView.mapView.removeAnnotations(homeView.mapView.annotations)
        let annotations = places.map { PlaceAnnotation(place: $0) }
        
        homeView.mapView.addAnnotations(annotations)
        if let firstAnnotation = annotations.first {
            homeView.mapView.setRegion(MKCoordinateRegion(center: firstAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true )
        }
    }
    
    private func filterPlaces(by category: Category) {
        let currentCenter = homeView.mapView.region.center
        homeViewModel.fetchPlaces(for: category.id, userLocation: currentCenter)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceTableViewCell.identifier, for: indexPath) as? PlaceTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: places[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        guard !(annotation is MKUserLocation) else { return nil }
         
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

            if let pinImage = UIImage(named: "mapIcon") {
                annotationView?.image = pinImage
                annotationView?.frame.size = CGSize(width: 50, height: 68)
            }
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard view.annotation is PlaceAnnotation else { return }
        
    }
}
