//
//  ListTopGamesCell.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol ListTopGamesCellDelegate {
    func imageDownloaded(image:String, index:Int)
}

class ListTopGamesCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    var delegate: ListTopGamesCellDelegate?
    var gameInfo: GameInfo?
    var index: Int?
    
    //MARK: Setup
    func setup(gameInfo: GameInfo, index: Int) {
        self.gameInfo = gameInfo
        self.index = index
        self.gameLabel.text = self.gameInfo?.name
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 4
        self.fetchGameImage()
    }
    
    private func fetchGameImage() {
        if let url = self.gameInfo?.logo.large {
            loadingView.startAnimating()
            gameImageView.af_setImage(withURL: URL(string: url)!, filter: AspectScaledToFitSizeFilter(size: gameImageView.frame.size), imageTransition: .crossDissolve(0.2), completion: { (imageResponse) in
                self.loadingView.stopAnimating()
                if let data = imageResponse.data {
                    if let image = UIImage(data: data) {
                        self.transformImageToString(image: image)
                    }
                }
            })
        }
    }
    
    private func transformImageToString(image:Image) {
        let imageData: Data = UIImagePNGRepresentation(image)!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        self.delegate?.imageDownloaded(image: strBase64, index: self.index!)
    }
}
