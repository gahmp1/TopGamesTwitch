//
//  ListTopGamesViewController.swift
//  TwitchGamesTop
//  Copyright © 2018 Joao Gabriel. All rights reserved.
//

import UIKit

protocol ListTopGamesDisplayLogic : class {
    func displayFetchedTopGames(viewModel: TopGames.Service.ViewModel)
    func displaySavedUpdateTopGamesCoreData(viewModel: TopGames.CoreData.SaveUpdate.ViewModel)
    func displayFetchedTopGamesCoreData(viewModel: TopGames.CoreData.Fetch.ViewModel)
    func displayDeletedTopGamesCoreData(viewModel: TopGames.CoreData.Delete.ViewModel)
}

class ListTopGamesViewController: UIViewController {

    
    //MARK: UI Properties
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomLoadingView: UIView!
    @IBOutlet weak var bottomLoadingHeight: NSLayoutConstraint!
    @IBOutlet weak var topInformationViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bottomLoading: UIActivityIndicatorView!
    @IBOutlet weak var middleLoading: UIActivityIndicatorView!
    //MARK: Properties
    var interactor: ListTopGamesBusinessLogic?
    var router: (NSObjectProtocol & ListTopGamesRoutingLogic)?
    let cellIdentifier = "ListTopGamesCell"
    var gamesViewModel: TopGames.Service.ViewModel?
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
        title = "List Top Games Twitch"
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
        setupView()
        checkSavedTopGames()
        doFetchFirstTopGames()
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        informationLabel.text = String.loc("NO_TOP_GAME_LIST_MESSAGE")
        collectionView.register(UINib(nibName: "ListTopGamesCell", bundle: .main), forCellWithReuseIdentifier: "ListTopGamesCell")
        
    }
    
    func checkSavedTopGames() {
        fetchListProductsInCoreData()
        
        let title = String.loc("OFFLINE_DATA_TITLE")
        let message = String.loc("OFFLINE_DATA_TITLE_MESSAGE")
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: String.loc("CANCEL_MESSAGE"), style: UIAlertActionStyle.default, handler: { (action) in
        }))
        alert.addAction(UIAlertAction(title: String.loc("ACCEPT_MESSAGE"), style: UIAlertActionStyle.default, handler: { (action) in
            self.middleLoading.startAnimating()
            self.doFetchFirstTopGames()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveListProductsInCoreData() {
        var request = TopGames.CoreData.SaveUpdate.Request()
        request.nextUrl = self.gamesViewModel?.games?._links.next ?? String.loc("FIRST_10_TOP_GAMES")
        request.listGames = self.listGames
        self.interactor?.saveUpdateTopGamesInCoreData(request: request)
    }
    
    func fetchListProductsInCoreData() {
        let request = TopGames.CoreData.Fetch.Request()
        self.interactor?.fetchTopGamesInCoreData(request: request)
    }
    
    
    func doFetchFirstTopGames() {
        middleLoading.startAnimating()
        var request = TopGames.Service.Request()
        request.url = String.loc("FIRST_10_TOP_GAMES")
        listGames = [Games]()
        callRequest(request: request)

    }
    
    func doFetchNextTopGames() {
        bottomLoading.startAnimating()
        var request = TopGames.Service.Request()
        request.url = gamesViewModel?.games?._links.next
        callRequest(request: request)
    }
    
    func callRequest(request: TopGames.Service.Request) {
        interactor?.fetchTopGames(request: request)
    }
    
    func updateListGames() {
        if let games = self.gamesViewModel?.games?.top {
            for game in games {
                self.listGames.append(game)
            }
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        doFetchFirstTopGames()
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
    }
    

}

//MARK: Collection view Data Source Delegate
extension ListTopGamesViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let topGamesCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListTopGamesCell else {
            return UICollectionViewCell()
        }
        if self.listGames.count > 0 {
            if let game = self.listGames[indexPath.row].game {
                topGamesCell.setup(game: game)
            }
        }
        return topGamesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width/2 - 8, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 2, left: 4, bottom: 2, right: 4)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.frame.size.height) {
            if bottomLoading.isAnimating == false && middleLoading.isAnimating == false {
                doFetchNextTopGames()
            }
            
        }
    }
}

//MARK: Display Logic Delegate
extension ListTopGamesViewController: ListTopGamesDisplayLogic {
    
    //MARK: Core Data Methods
    func displaySavedUpdateTopGamesCoreData(viewModel: TopGames.CoreData.SaveUpdate.ViewModel) {
        
    }
    
    func displayFetchedTopGamesCoreData(viewModel: TopGames.CoreData.Fetch.ViewModel) {
        
    }
    
    func displayDeletedTopGamesCoreData(viewModel: TopGames.CoreData.Delete.ViewModel) {
        
    }
    
    //MARK: Services Methods
    func displayFetchedTopGames(viewModel: TopGames.Service.ViewModel) {
        DispatchQueue.main.async {
            
            self.middleLoading.stopAnimating()
            self.bottomLoading.stopAnimating()
            
            if viewModel.games != nil {
                self.collectionView.isHidden = false
                self.gamesViewModel = viewModel
                self.updateListGames()
                self.saveListProductsInCoreData()
                self.collectionView.reloadData()
                
            } else{
                if self.listGames.count == 0 {
                    self.collectionView.isHidden = true
                }
                if let title = viewModel.alertTitle,let message = viewModel.alertMessage{
                    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        self.middleLoading.startAnimating()
                        self.doFetchFirstTopGames()

                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
}
