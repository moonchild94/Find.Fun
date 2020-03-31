//
//  RouteViewController.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 26.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit
import FloatingPanel
import MapKit
import Polyline

internal class RouteViewController: FloatableViewController {
    private let routeService = RouteService()
    
    @IBOutlet private weak var fromLabel: UILabel!
    
    @IBOutlet private weak var toLabel: UILabel!
    
    @IBOutlet private weak var durationLabel: UILabel!
    
    @IBOutlet private weak var distanceLabel: UILabel!
    
    @IBOutlet private weak var transportTypeImageView: UIImageView!
    
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var goButton: UIButton!
    
    @IBOutlet private weak var walkToolbarItem: UIBarButtonItem!
    
    @IBOutlet private weak var carToolbarItem: UIBarButtonItem!
    
    private var props: RouteProps?
    
    override weak var floatingPanelController: FloatingPanelController? {
        didSet {
            floatingPanelController?.delegate = self
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupCloseButton()
        setupGoButton()
    }
    
    @IBAction private func onTapGoButton(_ sender: Any) {
        props?.onTapGo()
    }
    
    @IBAction private func onTapCloseButton(_ sender: Any) {
        props?.onTapClose()
    }
    
    @IBAction private func onTapWalkToolBarItem(_ sender: UIBarButtonItem) {
        onTapTransportToolBarItem(with: .walk)
    }
    
    @IBAction private func onTapCarToolbarItem(_ sender: UIBarButtonItem) {
        onTapTransportToolBarItem(with: .car)
    }
    
    private func onTapTransportToolBarItem(with type: TransportType) {
        guard type != props?.selectedTransportType else { return }
        onSelectTransportType(type)
        props?.onRequestRoute(type)
    }
    
    private func onSelectTransportType(_ transportType: TransportType) {
        walkToolbarItem.tintColor = transportType == .walk ? .systemBlue : .systemGray
        carToolbarItem.tintColor = transportType == .car ? .systemBlue : .systemGray
        
        if #available(iOS 13.0, *) {
            transportTypeImageView.image = transportType == .walk
                ? UIImage(named: "walk.fill")
                : UIImage(systemName: "car.fill")
        } else {
            transportTypeImageView.image = transportType == .walk
                ? UIImage(named: "walk.fill")
                : UIImage(named: "car.fill")
        }
        
        transportTypeImageView.image = transportTypeImageView.image?.withRenderingMode(.alwaysTemplate)
        transportTypeImageView.tintColor = .systemGray
    }
    
    private func setupCloseButton() {
        closeButton.imageView?.contentMode = .scaleAspectFill
        closeButton.imageView?.image = closeButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        closeButton.imageView?.tintColor = UIColor(named: "CloseButtonColor")
    }
    
    private func setupGoButton() {
        goButton.layer.cornerRadius = 8
    }
}

extension RouteViewController: RouteRenderer {
    func render(props: RouteProps) {
        let oldProps = self.props
        self.props = props
        
        toLabel.text = props.title
        durationLabel.text = "\(props.duration / 60) min"
        distanceLabel.text = "\(props.distance) m"
        
        if props.selectedTransportType != oldProps?.selectedTransportType {
            onSelectTransportType(props.selectedTransportType)
        }
    }
}

extension RouteViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return RouteFloatingPanelLayout()
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController,
                                     withVelocity velocity: CGPoint,
                                     targetPosition: FloatingPanelPosition) {
        switch targetPosition {
        case .tip:
            if toLabel.numberOfVisibleLines > 1 {
                fromLabel.isHidden = true
            }
        default:
            fromLabel.isHidden = false
        }
    }
}
