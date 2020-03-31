//
//  PageDetailsViewController.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 25.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel
import Kingfisher

class PageDetailsViewController: FloatableViewController {
    private enum Constants {
        static let galleryReuseIdentifier = String(describing: ImageCollectionViewCell.self)
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var linkLabel: UILabel!
    
    @IBOutlet private weak var directionsButton: UIButton!
    
    @IBOutlet private weak var photoGalleryView: UICollectionView!
        
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet private weak var loadingImagesActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var directionsButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var directionsButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var hiddenDirectionsButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var hiddenDirectionsButtonTopConstraint: NSLayoutConstraint!
    
    override weak var floatingPanelController: FloatingPanelController? {
        didSet {
            floatingPanelController?.delegate = self
        }
    }

    var props: PageDetailsProps?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupLinkLabel()
        setupDirectionsButton()
        setupPhotoGalleryView()
        setupActivityIndicator()
        setupCloseButton()
    }
    
    @IBAction private func onTapCloseButton(_ sender: Any) {
        props?.onTapClose()
    }
    
    @IBAction private func onTapDirectionButton(_ sender: Any) {
        props?.onTapDirections()
    }
    
    private func setupLinkLabel() {
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapLink)))
    }
    
    private func setupDirectionsButton() {
        directionsButton.layer.cornerRadius = 8
    }
    
    private func setupPhotoGalleryView() {
        photoGalleryView.dataSource = self
        photoGalleryView.delegate = self
        
        photoGalleryView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.galleryReuseIdentifier)
        
        photoGalleryView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        
        if let layout = photoGalleryView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = CGSize(width: 200, height: 200)
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func setupActivityIndicator() {
        if #available(iOS 13.0, *) {
            loadingImagesActivityIndicator.style = .medium
        }
    }
    
    private func setupCloseButton() {
        closeButton.imageView?.contentMode = .scaleAspectFill
        closeButton.imageView?.image = closeButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        closeButton.imageView?.tintColor = UIColor(named: "CloseButtonColor")
    }
    
    @objc private func onTapLink() {
        if let props = props, let url = URL(string: props.info.url) {
            UIApplication.shared.open(url)
        }
    }
}

extension PageDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return props?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = photoGalleryView.dequeueReusableCell(withReuseIdentifier: Constants.galleryReuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        guard indexPath.row < props?.images?.count ?? 0,
            let prop = props?.images?[indexPath.row] else { return cell }
        
        cell.dimensions = (prop.thumbWidth, prop.thumbHeight)
        cell.imageView.kf.setImage(with: URL(string: prop.thumbUrl))
        cell.imageView.kf.indicatorType = .activity

        return cell
    }
}

extension PageDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < props?.images?.count ?? 0,
            let prop = props?.images?[indexPath.row],
            let url = URL(string: prop.url) else { return }
        UIApplication.shared.open(url)
    }
}

extension PageDetailsViewController: PageDetailsRenderer {
    func render(props: PageDetailsProps) {
        let oldProps = self.props
        self.props = props
        
        titleLabel.text = props.info.title
        showLink(props.info.url)
        showDescription(props.info.description, with: props.info.distance)
        showDirections(props.showDirections)
        
        if props.images == nil {
            props.onRequestImages(Int(UIScreen.main.scale))
            return
        }
        
        if oldProps?.images == nil {
            self.loadingImagesActivityIndicator.stopAnimating()
        }
             
        photoGalleryView.reloadData()
    }
    
    private func showDirections(_ showDirections: Bool) {
        directionsButton.isHidden = !showDirections
        
        directionsButtonHeightConstraint.isActive = showDirections
        hiddenDirectionsButtonHeightConstraint.isActive = !showDirections
        
        directionsButtonTopConstraint.isActive = showDirections
        hiddenDirectionsButtonTopConstraint.isActive = !showDirections
    }
    
    private func showLink(_ link: String) {
        let attributes: [NSAttributedString.Key : Any] =  [
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .font : UIFont.systemFont(ofSize: 17)
        ]
        linkLabel.attributedText = NSAttributedString(string: link, attributes: attributes)
    }
    
    private func showDescription(_ description: String?, with distance: Int) {
        var fullDescription = "\(distance) m"
        if let description = description {
            fullDescription += " • \(description)"
        }
        descriptionLabel.text = fullDescription
    }
}

extension PageDetailsViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return PageDetailsFloatingPanelLayout()
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController,
                                     withVelocity velocity: CGPoint,
                                     targetPosition: FloatingPanelPosition) {
        switch targetPosition {
        case .tip:
            descriptionLabel.numberOfLines = 1
            linkLabel.isHidden = true
            if titleLabel.numberOfVisibleLines > 1 {
                descriptionLabel.isHidden = true
            }
        default:
            descriptionLabel.numberOfLines = 2
            linkLabel.isHidden = false
            descriptionLabel.isHidden = false
        }
    }
}
