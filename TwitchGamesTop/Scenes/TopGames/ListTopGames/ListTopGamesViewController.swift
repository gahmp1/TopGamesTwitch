//
//  ListTopGamesViewController.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import UIKit

protocol ListTopGamesDisplayLogic : class {
    func displayFetchedTopGames(viewModel: TopGames.ViewModel)
}

class ListTopGamesViewController: UIViewController {


    //MARK: UI Properties
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var customLoading:CustomLoading!
    
    //MARK: Properties
    var interactor: ListTopGamesBusinessLogic?
    var router: (NSObjectProtocol & ListTopGamesRoutingLogic)?
    let cellIdentifier = "ListTopGamesCell"
    var gamesViewModel: TopGames.ViewModel?
    var listGames = [Games]()
    
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
        let viewController = self
        let interactor = ListTopGamesInteractor()
        let presenter = ListTopGamesPresenter()
        let router = ListTopGamesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        informationLabel.text = String.loc("NO_TOP_GAME_LIST_MESSAGE")
        collectionView.register(UINib(nibName: "ListTopGamesCell", bundle: .main), forCellWithReuseIdentifier: "ListTopGamesCell")
        doFetchTopGames()
    }
    
    func doFetchTopGames() {
        customLoading = CustomLoading(view: view)
        customLoading.show()
        let request = TopGames.Request()
        interactor?.fetchTopGames(request: request)
    }
    
    func configureView() {
        if let games = self.gamesViewModel?.games?.top {
            for game in games {
                self.listGames.append(game)
            }
        self.collectionView.reloadData()
        }
    }
    

}

extension ListTopGamesViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let topGamesCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListTopGamesCell else {
            return UICollectionViewCell()
        }
        topGamesCell.setup(game: self.listGames[indexPath.row].game)
        return topGamesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width/2 - 8, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 2, left: 4, bottom: 2, right: 4)
    }
}

//MARK: Display Logic Delegate
extension ListTopGamesViewController: ListTopGamesDisplayLogic {
    func displayFetchedTopGames(viewModel: TopGames.ViewModel) {
        DispatchQueue.main.async {
            
            self.customLoading.hide()
            
            if viewModel.games != nil {
                self.collectionView.isHidden = false
                self.gamesViewModel = viewModel
                self.configureView()
                
            } else{
                if self.listGames.count == 0 {
                    self.collectionView.isHidden = true
                }
                if let title = viewModel.alertTitle,let message = viewModel.alertMessage{
                    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.customLoading.show()
                        self.doFetchTopGames()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
}
