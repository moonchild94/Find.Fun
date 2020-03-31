//
//  MapPresenter.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 29.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

internal struct MapProps {
    let userCoordinate: Coordinate?
    let pages: [PageInfo]
    let selected: Int
    let route: String?
    let error: Error?
    let onRefresh: () -> Void
    let onSelectPagePoint: (Int) -> Void
    let onDeselectPagePoint: () -> Void
    let state: MapState
    
    struct PageInfo: Equatable {
        let title: String
        let description: String?
        let url: String
        let coordinate: Coordinate
    }
}

internal enum MapState {
    case regular
    case routing
    case navigating
}

internal protocol MapRenderer: NSObjectProtocol {
    func render(props: MapProps)
}

internal class MapPresenter: NSObject, Presenter {
    private let locationManager: LocationManager
    private let wikiService: WikiService
    
    private var cachedPages: [PageInfo] = []
    private var visiblePages: [PageInfo] = []
    
    private var route: String?
    
    private var selected: Int = .noSelectedPageIndex
    private var userCoordinate: Coordinate?
    private var following: Bool = false
    
    weak var renderer: MapRenderer?
    
    weak var coordinator: Coordinator?
    
    var state: MapState = .regular {
        didSet {
            switch state {
            case .regular:
                visiblePages = cachedPages
            case .routing:
                guard oldValue == .regular else { break }
                visiblePages = [cachedPages[selected]]
            case .navigating:
                break
            }
                            
            renderCurrentState()
        }
    }
        
    init(locationManager: LocationManager, wikiService: WikiService) {
        self.locationManager = locationManager
        self.wikiService = wikiService
                
        super.init()
        
        locationManager.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDidReceiveRoute),
                                               name: .didReceiveRoute,
                                               object: nil)
    }
    
    func start() {
        checkStatusAndFetchImageInfos()
    }
    
    func onDeselectPagePoint() {
        selected = .noSelectedPageIndex
        renderCurrentState()
    }
    
    @objc private func onDidReceiveRoute(_ notification: Notification) {
        guard let data = notification.userInfo as? [String: String],
            let route = data[NotificationKeys.route] else { return }
        
        self.route = route
        renderCurrentState()
    }
    
    private func checkStatusAndFetchImageInfos() {
        switch locationManager.status() {
        case .turnedOff:
            self.render(error: MapError.locationTurnedOff)
        // Actually, authorizedAlways can't happen but it lets to get location too
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            fallthrough
        case .authorizedAlways, .authorizedWhenInUse:
            fetchPageInfos()
        case .restricted:
            self.render(error: MapError.locationRestricted)
        case .denied:
            self.render(error: MapError.locationDenied)
        }
    }
    
    private func renderCurrentState() {
        render(coordinate: userCoordinate,
               pages: visiblePages,
               route: route,
               selected: selected,
               state: state)
    }
    
    private func render(coordinate: Coordinate? = nil,
                        pages: [PageInfo] = [],
                        route: String? = nil,
                        selected: Int = .noSelectedPageIndex,
                        error: Error? = nil,
                        state: MapState = .regular) {
        let onSelectPagePoint = { [weak self] (pageIndex: Int) in
            guard let self = self, let coordinator = self.coordinator else { return }
            self.selected = pageIndex
            coordinator.showPageDetailsViewController(for: pages[pageIndex], routable: state == .regular)
        }
        
        let onDeselectPagePoint = { [weak self] in
            guard let self = self, let coordinator = self.coordinator else { return }
            self.selected = .noSelectedPageIndex
            coordinator.closePageDetailsViewController(manually: false)
        }
        
        let props = MapProps(userCoordinate: coordinate,
                             pages: pages.compactMap { $0.convertToPageInfoProps() },
                             selected: selected,
                             route: route,
                             error: error,
                             onRefresh: self.checkStatusAndFetchImageInfos,
                             onSelectPagePoint: onSelectPagePoint,
                             onDeselectPagePoint: onDeselectPagePoint,
                             state: state)
                
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.renderer?.render(props: props)
        }
    }
    
    private func fetchPageInfos() {
        guard let coordinate = locationManager.coordinate else {
            locationManager.startUpdatingLocation()
            return
        }
        
        userCoordinate = coordinate
        fetchPageInfos(for: coordinate)
    }
    
    private func fetchPageInfos(for coordinate: Coordinate) {
        wikiService.getPagesInfos(near: coordinate, for: 3000, with: 100) { [weak self] response, error in
            guard let self = self else { return }
            
            self.cachedPages = response?.pages ?? []
            self.visiblePages = self.cachedPages
            
            self.render(coordinate: coordinate, pages: self.visiblePages, error: error)
        }
    }
}

extension MapPresenter: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateCoordinates coordinates: [Coordinate]) {
        guard let coordinate = coordinates.last else { return }
        
        locationManager.stopUpdatingLocation()
        
        userCoordinate = coordinate
        fetchPageInfos(for: coordinate)
    }
}

internal enum MapError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationTurnedOff:
            return "Location is turned off"
        case .locationRestricted:
            return "Location is restricted"
        case .locationDenied:
            return "Location is denied"
        }
    }
    
    case locationTurnedOff
    case locationRestricted
    case locationDenied
}

extension Int {
    static let noSelectedPageIndex = -1
}

private extension PageInfo {
    func convertToPageInfoProps() -> MapProps.PageInfo? {
        guard let coordinate = locations.last?.convertToCoordinate() else { return nil }
        return MapProps.PageInfo(title: title,
                                 description: description,
                                 url: url,
                                 coordinate: coordinate)
    }
}
