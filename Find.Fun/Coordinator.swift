//
//  Coordinator.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 29.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit
import FloatingPanel

internal class Coordinator {
    let rootViewController: UIViewController
    
    let mapPresenter: MapPresenter
    
    var pageDetailsPresenter: PageDetailsPresenter?
    weak var pageDetailsFloatingPanelController: FloatingPanelController?
    
    var routePresenter: RoutePresenter?
    weak var routeFloatingPanelController: FloatingPanelController?
    
    var navigationPresenter: NavigationPresenter?
    weak var navigationFloatingPanelController: FloatingPanelController?
    
    init() {
        let mapViewController = MapViewController()
        rootViewController = mapViewController
        
        mapPresenter = MapPresenter(locationManager: LocationManager(), wikiService: WikiService())
        mapPresenter.renderer = mapViewController
        mapPresenter.coordinator = self
        mapPresenter.start()
    }
    
    func showPageDetailsViewController(for page: PageInfo, routable: Bool) {
        hideRouteViewController { [weak self] in
            guard let self = self else { return }
            
            let controller = PageDetailsViewController()
            
            let presenter = PageDetailsPresenter(wikiService: WikiService(),
                                                 page: page,
                                                 showDirections: routable)
            presenter.renderer = controller
            presenter.coordinator = self
            self.pageDetailsPresenter = presenter
            
            showViewControllerInFloatingPanel(controller, onTop: self.rootViewController)
            self.pageDetailsFloatingPanelController = controller.floatingPanelController
            
            presenter.start()
        }
    }
    
    func closePageDetailsViewController(manually: Bool, completion: @escaping () -> Void = {}) {
        pageDetailsPresenter = nil
        
        guard let pageDetailsFloatingPanelController = pageDetailsFloatingPanelController else {
            completion()
            return
        }
        
        pageDetailsFloatingPanelController.removePanelFromParent(animated: true) { [weak self] in
            guard let self = self else { return }
            
            if manually {
                self.mapPresenter.onDeselectPagePoint()
            }
            
            if self.navigationPresenter == nil {
                self.showHidedRouteViewController()
            }
            
            completion()
        }
    }
    
    func showRouteViewController(for page: PageInfo) {
        closePageDetailsViewController(manually: false) { [weak self] in
            guard let self = self else { return }
            
            self.mapPresenter.state = .routing
            
            let controller = RouteViewController()
            
            let presenter = RoutePresenter(routeService: RouteService(),
                                           locationManager: LocationManager(),
                                           page: page)
            presenter.renderer = controller
            presenter.coordinator = self
            self.routePresenter = presenter
            
            showViewControllerInFloatingPanel(controller, onTop: self.rootViewController)
            self.routeFloatingPanelController = controller.floatingPanelController
            
            presenter.start()
        }
    }
    
    func closeRouteViewController() {
        routePresenter = nil
        self.mapPresenter.state = .regular
        
        routeFloatingPanelController?.removePanelFromParent(animated: true)
    }
    
    func showNavigationViewController(for coordinate: Coordinate, with transportType: TransportType) {
        hideRouteViewController() { [weak self] in
            guard let self = self else { return }
            
            self.mapPresenter.state = .navigating
            
            let controller = NavigationViewController()
            
            let presenter = NavigationPresenter(routeService: RouteService(),
                                                locationManager: LocationManager(),
                                                to: coordinate,
                                                transportType: transportType)
            presenter.renderer = controller
            presenter.coordinator = self
            self.navigationPresenter = presenter
            
            showViewControllerInFloatingPanel(controller, onTop: self.rootViewController)
            self.navigationFloatingPanelController = controller.floatingPanelController
            
            presenter.start()
        }
    }
    
    func closeNavigationViewController() {
        navigationPresenter = nil
        self.mapPresenter.state = .routing
        
        navigationFloatingPanelController?.removePanelFromParent(animated: true) { [weak self] in
            guard let self = self else { return }
            self.showHidedRouteViewController()
            return
        }
    }
    
    private func showHidedRouteViewController() {
        self.routeFloatingPanelController?.show(animated: true)
    }
    
    private func hideRouteViewController(completion: @escaping () -> Void) {
        guard let routeFloatingPanelController = routeFloatingPanelController else {
            completion()
            return
        }
        
        routeFloatingPanelController.hide(animated: true) {
            completion()
        }
    }
}

private func showViewControllerInFloatingPanel(_ viewController: FloatableViewController,
                                               onTop parent: UIViewController,
                                               animated: Bool = true) {
    let floatingPanelController = FloatingPanelController()
    floatingPanelController.surfaceView.backgroundColor = .clear
    floatingPanelController.set(contentViewController: viewController)
    viewController.floatingPanelController = floatingPanelController
    floatingPanelController.addPanel(toParent: parent, animated: animated)
}
