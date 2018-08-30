//
//  DetailTopGameViewController.swift
//  TwitchGamesTop
//
//  Created by Banco Santander Brasil on 29/08/18.
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol DetailTopGameDisplayLogic : class {
    func displayFetchedTopGames(viewModel: TopGameDetail.ViewModel)
}

class DetailTopGameViewController: UIViewController {

    
    //MARK: UI Properties
    @IBOutlet weak var viewersLabel: UILabel!
    @IBOutlet weak var channelsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!

    //MARK: Properties
    var interactor: DetailTopGameBusinessLogic?
    var game : Games?
    
    //MARK: Constructors
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        title = "Detail Top Game Twitch"
        let viewController = self
        let interactor = DetailTopGameInteractor()
        let presenter = DetailTopGamePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameImageView.layer.cornerRadius = 10
        self.loadingView.startAnimating()
        let request = TopGameDetail.Request(game: game)
        self.interactor?.fetchDetailTopGame(request: request)
    }

}

extension DetailTopGameViewController: DetailTopGameDisplayLogic {
    func displayFetchedTopGames(viewModel: TopGameDetail.ViewModel) {
        if let error = viewModel.error {
            self.errorLabel.text = error
            self.contentView.isHidden = true
        }
        if let name = viewModel.games?.game?.name {
            self.nameLabel.text = name
        }
        
        if let image = viewModel.games?.game?.image {
            let dataDecoded : Data = Data(base64Encoded: image, options: .ignoreUnknownCharacters)!
            if let decodedimage = UIImage(data: dataDecoded) {
                self.gameImageView.image = decodedimage
                self.loadingView.stopAnimating()
            }
        } else {
            if let url = viewModel.games?.game?.logo.large {
                self.gameImageView.af_setImage(withURL: URL(string: url)!, filter: AspectScaledToFitSizeFilter(size: gameImageView.frame.size), imageTransition: .crossDissolve(0.2), completion: { (imageResponse) in
                    self.loadingView.stopAnimating()
                })
            }
        }
        
        if let channels = viewModel.games?.channels {
            self.channelsLabel.text = String(format: "Channels: %i", arguments: [channels])
        }
        
        if let viewers = viewModel.games?.viewers {
            self.viewersLabel.text = String(format: "Viewers: %i", arguments: [viewers])
        }
        
        
    }
}
