//
//  ListTopGamesCell.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class ListTopGamesCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    
    var game: Game?
    
    //MARK: Setup
    func setup(game: Game) {
        self.game = game
        self.gameLabel.text = self.game?.name
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 4
        self.fetchGameImage()
    }
    
    private func fetchGameImage() {
        if let url = self.game?.logo.large {
            let customLoading = CustomLoading(view: self)
            customLoading.show()
            gameImageView.af_setImage(withURL: URL(string: url)!, filter: AspectScaledToFitSizeFilter(size: gameImageView.frame.size), imageTransition: .crossDissolve(0.2), completion: { (image) in
                customLoading.hide()
        })
        }
    }
}
