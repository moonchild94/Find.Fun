//
//  PageDetailsPresenter.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 29.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

internal struct PageDetailsProps {
    let info: PageInfo
    let images: [ImageProps]?
    let showDirections: Bool
    
    let onRequestImages: (Int) -> Void
    let onTapDirections: () -> Void
    let onTapClose: () -> Void
    
    struct PageInfo {
        let title: String
        let description: String?
        let distance: Int
        let url: String
    }
    
    struct ImageProps {
        let url: String
        let thumbUrl: String
        let thumbWidth: Int
        let thumbHeight: Int
    }
}

internal protocol PageDetailsRenderer: NSObjectProtocol {
    func render(props: PageDetailsProps)
}

internal class PageDetailsPresenter: Presenter {
    private let wikiService: WikiService
    
    private let page: PageInfo
    private let showDirections: Bool
    
    weak var coordinator: Coordinator?
    weak var renderer: PageDetailsRenderer?
    
    init(wikiService: WikiService, page: PageInfo, showDirections: Bool) {
        self.wikiService = wikiService
        self.page = page
        self.showDirections = showDirections
    }
    
    func start() {
        render()
    }
    
    private func render(with images: [PageDetailsProps.ImageProps]? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.renderer?.render(props: self.buildProps(with: images))
        }
    }
    
    private func buildProps(with images: [PageDetailsProps.ImageProps]?) -> PageDetailsProps {
        let pageInfo = page.convertToPageInfoProps()
        
        let onTapClose = { [weak self] in
            guard let coordinator = self?.coordinator else { return }
            coordinator.closePageDetailsViewController(manually: true)
        }
        
        let onTapDirections = { [weak self] in
            guard let self = self, let coordinator = self.coordinator else { return }
            coordinator.showRouteViewController(for: self.page)
        }
        
        return PageDetailsProps(info: pageInfo,
                                images: images,
                                showDirections: showDirections,
                                onRequestImages: self.fetchImageUrls,
                                onTapDirections: onTapDirections,
                                onTapClose: onTapClose)
    }
    
    private func fetchImageUrls(with scale: Int) {
        fetchImageUrls(for: page, with: scale)
    }
    
    private func fetchImageUrls(for page: PageInfo, with scale: Int) {
        wikiService.getImagesInfos(for: page.id, with: scale) { [weak self] response, error in
            guard let self = self else { return }
            
            guard let response = response, error == nil else {
                self.render(with: [])
                return
            }
            
            let infos = response.infos
                .filter { $0.mediaType == .bitmap }
                .map { info in
                    PageDetailsProps.ImageProps(url: info.url,
                                                thumbUrl: info.thumbUrl,
                                                thumbWidth: info.thumbWidth / scale,
                                                thumbHeight: info.thumbHeight / scale)
            }
            
            self.render(with: infos)
        }
    }
}

private extension PageInfo {
    func convertToPageInfoProps() -> PageDetailsProps.PageInfo {
        let distance = !locations.isEmpty ? Int(locations.last?.distance ?? 0) : 0
        return PageDetailsProps.PageInfo(title: title,
                                         description: description,
                                         distance: distance,
                                         url: url)
    }
}
