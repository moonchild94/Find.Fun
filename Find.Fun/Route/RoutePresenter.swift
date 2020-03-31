//
//  RoutePresenter.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 30.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

internal struct RouteProps {
    let title: String
    let duration: Int
    let distance: Int
    let selectedTransportType: TransportType
    let onRequestRoute: (TransportType) -> Void
    let onTapGo: () -> Void
    let onTapClose: () -> Void
}

internal protocol RouteRenderer: NSObjectProtocol {
    func render(props: RouteProps)
}

internal class RoutePresenter: Presenter {
    weak var coordinator: Coordinator?
    weak var renderer: RouteRenderer?
    
    private let routeService: RouteService
    private let locationManager: LocationManager
    private let page: PageInfo
    
    init(routeService: RouteService, locationManager: LocationManager, page: PageInfo) {
        self.routeService = routeService
        self.locationManager = locationManager
        self.page = page
    }

    func start() {
        render()
        fetchRoutes(with: .walk)
    }
    
    private func render(duration: Int = 0, distance: Int = 0, transportType: TransportType = .walk) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.renderer?.render(props: self.buildProps(duration: duration,
                                                         distance: distance,
                                                         transportType: transportType))
        }
    }
    
    private func buildProps(duration: Int, distance: Int, transportType: TransportType) -> RouteProps {
        let onTapClose = { [weak self] in
            guard let coordinator = self?.coordinator else { return }
            coordinator.closeRouteViewController()
        }
        
        let onTapGo = { [weak self] in
            guard let self = self,
                let coordinator = self.coordinator,
                let coordinate = self.page.locations.last?.convertToCoordinate() else { return }
            coordinator.showNavigationViewController(for: coordinate, with: transportType)
        }
        
        return RouteProps(title: page.title,
                          duration: duration,
                          distance: distance,
                          selectedTransportType: transportType,
                          onRequestRoute: self.fetchRoutes(with:),
                          onTapGo: onTapGo,
                          onTapClose: onTapClose)
    }
    
    private func fetchRoutes(with type: TransportType) {
        guard let from = locationManager.coordinate,
            let to = page.locations.last?.convertToCoordinate() else  { return }
        fetchRoutes(from: from, to: to, with: type)
    }
    
    private func fetchRoutes(from: Coordinate, to: Coordinate, with type: TransportType) {
        routeService.fetchRoutes(from: from, to: to, type: type) { [weak self] result, error in
            guard let self = self, let result = result, error == nil else { return }
            NotificationCenter.default.post(name: .didReceiveRoute,
                                            object: nil,
                                            userInfo: [NotificationKeys.route: result.encodedPolyline])
            self.render(duration: result.duration, distance: result.distance, transportType: type)
        }
    }
}
