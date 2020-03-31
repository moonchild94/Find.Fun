//
//  MapViewController.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 24.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel
import NotificationBannerSwift

internal class MapViewController: UIViewController {
    
    private enum Constants {
        static let clusterReuseIdentifier = "cluster"
        static let singleReuseIdentifier = "single"
        
        static let routingMapRectInsets = UIEdgeInsets(top: 50, left: 50.0, bottom: 290.0, right: 50.0)
    }
    
    @IBOutlet private weak var mapView: MKMapView!
    
    @IBOutlet private weak var refreshButton: UIButton!

    @IBOutlet private weak var centerOnUserButton: UIButton!
    
    private var navigationFloatingPanelController: FloatingPanelController?
    
    private var props: MapProps?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupRefreshButton()
        setupCenterOnUserButton()
        setupMapView()
    }
    
    @IBAction private func onTapRefresh(_ sender: Any) {
        props?.onRefresh()
    }
    
    @IBAction private func onTapCenterOnUser(_ sender: Any) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    private func setupRefreshButton() {
        refreshButton.imageView?.contentMode = .scaleAspectFit
        refreshButton.layer.cornerRadius = 8
        refreshButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupCenterOnUserButton() {
        centerOnUserButton.imageView?.contentMode = .scaleAspectFit
        centerOnUserButton.layer.cornerRadius = 8
        centerOnUserButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.showsScale = true
        
        mapView.register(PageMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: Constants.singleReuseIdentifier)
        mapView.register(ClusterMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: Constants.clusterReuseIdentifier)
    }

    private func showErrorBanner(with message: String) {
        let banner = StatusBarNotificationBanner(title: message, style: .danger)
        banner.show(on: self)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.singleReuseIdentifier, for: annotation) as? PageMarkerAnnotationView else {
                return PageMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.clusterReuseIdentifier)
            }
            
            return view
        }
        
        if annotation is MKClusterAnnotation {
            guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.clusterReuseIdentifier, for: annotation) as? ClusterMarkerAnnotationView else {
                return ClusterMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.clusterReuseIdentifier)
            }
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        
        mapView.setCenter(annotation.coordinate, animated: true)
        
        if let index = (annotation as? PageAnnotation)?.index {
            props?.onSelectPagePoint(index)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        props?.onDeselectPagePoint()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.systemBlue
        return renderer
    }
}

extension MapViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        switch vc {
        case navigationFloatingPanelController:
            return NavigationFloatingPanelLayout()
        default:
            return nil
        }
    }
}

extension MapViewController: MapRenderer {
    func render(props: MapProps) {
        let oldProps = self.props
        self.props = props
        
        if let error = props.error {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showErrorBanner(with: error.localizedDescription)
            }
            return
        }
        
        if !mapView.selectedAnnotations.isEmpty && props.selected == .noSelectedPageIndex {
            mapView.deselectAnnotation(mapView.selectedAnnotations[0], animated: true)
        }
        
        if props.route != oldProps?.route {
            mapView.removeOverlays(mapView.overlays)
            if let route = props.route, let polyline = MKPolyline.from(encoded: route) {
                mapView.addOverlay(polyline, level: .aboveRoads)
                if props.state == .routing {
                    mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: Constants.routingMapRectInsets, animated: true)
                }
            }
        }
        
        applyMapState(props.state)
                
        guard props.pages != oldProps?.pages else { return }
         
        let annotations = props.pages.enumerated().map { index, page -> MKPointAnnotation in
            let annotation = PageAnnotation()
            annotation.title = page.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: page.coordinate.latitude,
                                                           longitude: page.coordinate.longitude)
            annotation.index = index
            return annotation
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
                        
            if let userCoordinate = props.userCoordinate, userCoordinate != oldProps?.userCoordinate {
                self.mapView.showsUserLocation = true
                self.centerMapByCoordinate(CLLocationCoordinate2D(latitude: userCoordinate.latitude,
                                                                  longitude: userCoordinate.longitude))
            }
        }
    }
    
    private func applyMapState(_ state: MapState) {
        refreshButton.isHidden = state != .regular
        centerOnUserButton.layer.maskedCorners = state == .regular
            ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            : [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]

        mapView.setUserTrackingMode(state == .navigating ? .followWithHeading : .none, animated: true)
        
        if state == .regular {
            mapView.removeOverlays(self.mapView.overlays)
        }
    }
    
    private func centerMapByCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 2000,
                                        longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
}
