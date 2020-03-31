//
//  NavigationViewController.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 27.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

internal class NavigationViewController: FloatableViewController {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    private var props: NavigationProps?

    @IBOutlet private weak var arrivalValueLabel: UILabel!
    
    @IBOutlet private weak var durationValueLabel: UILabel!
    
    @IBOutlet private weak var distanceValueLabel: UILabel!
    
    @IBOutlet weak var endButton: UIButton!
    
    override weak var floatingPanelController: FloatingPanelController? {
        didSet {
            floatingPanelController?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupEndButton()
    }

    @IBAction private func onTapEndButton(_ sender: Any) {
        props?.onTapEnd()
    }
    
    private func setupView() {
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupEndButton() {
        endButton.layer.cornerRadius = 8
    }
}

extension NavigationViewController: NavigationRenderer {
    func render(props: NavigationProps) {
        self.props = props
        
        let arrival: Date = Date().addingTimeInterval(TimeInterval(props.duration))
        arrivalValueLabel.text = self.dateFormatter.string(for: arrival)
        
        let distance = Double(props.distance) / 1000
        durationValueLabel.text = "\(props.duration / 60) min"
        
        distanceValueLabel.text = "\(String(format: "%.1f", distance)) km"
    }
}

extension NavigationViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return NavigationFloatingPanelLayout()
    }
}
