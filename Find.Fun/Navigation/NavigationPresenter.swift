//
//  NavigationPresenter.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 30.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

internal struct NavigationProps {
    let duration: Int
    let distance: Int
    let onTapEnd: () -> Void
}

internal protocol NavigationRenderer: NSObjectProtocol {
    func render(props: NavigationProps)
}


internal class NavigationPresenter: NSObject, Presenter {
    weak var coordinator: Coordinator?
    weak var renderer: NavigationRenderer?
    
    private let locationManager: LocationManager
    private let routeService: RouteService
    
    private let to: Coordinate
    private let transportType: TransportType
    
    init(routeService: RouteService,
         locationManager: LocationManager,
         to: Coordinate,
         transportType: TransportType) {
        self.locationManager = locationManager
        self.routeService = routeService
        
        self.to = to
        self.transportType = transportType
        
        super.init()
        
        locationManager.delegate = self
        applyTransportType(transportType)
    }
    
    func start() {
        fetchRoutes()
    }
    
    private func applyTransportType(_ type: TransportType) {
        switch type {
        case .walk:
            locationManager.activityType = .otherNavigation
            locationManager.distanceFilter = 50
        case .car:
            locationManager.activityType = .automotiveNavigation
            locationManager.distanceFilter = 100
        }
    }
    
    private func fetchRoutes() {
        guard let from = locationManager.coordinate else  { return }
        fetchRoutes(from: from, to: to, with: transportType)
    }
    
    private func fetchRoutes(from: Coordinate, to: Coordinate, with type: TransportType) {
        routeService.fetchRoutes(from: from, to: to, type: type) { [weak self] result, error in
            guard let self = self, let result = result else { return }
            
            let onTapEnd = { [weak self] in
                guard let coordinator = self?.coordinator else { return }
                coordinator.closeNavigationViewController()
            }
            
            NotificationCenter.default.post(name: .didReceiveRoute,
                                            object: nil,
                                            userInfo: [NotificationKeys.route: result.encodedPolyline])
            
            let props = NavigationProps(duration: result.duration,
                                        distance: result.duration,
                                        onTapEnd: onTapEnd)
            self.renderer?.render(props: props)
        }
    }
}

extension NavigationPresenter: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateCoordinates coordinates: [Coordinate]) {
        guard let coordinate = coordinates.last else { return }
        fetchRoutes(from: coordinate, to: to, with: transportType)
    }
}
