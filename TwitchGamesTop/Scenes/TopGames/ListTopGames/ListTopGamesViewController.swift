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
    @IBOutlet weak var topInformationLabel: UILabel!
    @IBOutlet weak var bottomLoading: UIActivityIndicatorView!
    @IBOutlet weak var middleLoading: UIActivityIndicatorView!
    @IBOutlet weak var gameSearchBar: UISearchBar!
    
    //MARK: Properties
    var interactor: ListTopGamesBusinessLogic?
    var router: (NSObjectProtocol & ListTopGamesRoutingLogic)?
    let cellIdentifier = "ListTopGamesCell"
    var gamesViewModel: TopGames.Service.ViewModel?
    var listGames = [Games?]()
    var listGamesChangeable = [Games?]()
    var nextUrlCoreData = ""
    
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
        fetchListProductsInCoreData()
    }
    
    func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        gameSearchBar.delegate = self
        informationLabel.text = String.loc("NO_TOP_GAME_LIST_MESSAGE")
        collectionView.register(UINib(nibName: "ListTopGamesCell", bundle: .main), forCellWithReuseIdentifier: "ListTopGamesCell")
        
    }
    
    func saveListProductsInCoreData() {
        var request = TopGames.CoreData.SaveUpdate.Request()
        request.nextUrl = self.gamesViewModel?.games?._links.next ?? String.loc("FIRST_10_TOP_GAMES")
        if let games = self.listGames as? [Games] {
            request.listGames = games
        }
        self.interactor?.saveUpdateTopGamesInCoreData(request: request)
    }
    
    func fetchListProductsInCoreData() {
        let request = TopGames.CoreData.Fetch.Request()
        middleLoading.startAnimating()
        self.collectionView.isHidden = true
        self.interactor?.fetchTopGamesInCoreData(request: request)
    }
    
    
    func doFetchFirstTopGames() {
        self.middleLoading.startAnimating()
        var request = TopGames.Service.Request()
        request.url = String.loc("FIRST_10_TOP_GAMES")
        self.listGames = [Games]()
        self.listGamesChangeable = self.listGames
        self.callFetchRequest(request: request)

    }
    
    func doFetchNextTopGames() {
        bottomLoading.startAnimating()
        var request = TopGames.Service.Request()
        request.url = gamesViewModel?.games?._links.next ?? nextUrlCoreData
        callFetchRequest(request: request)
    }
    
    func callFetchRequest(request: TopGames.Service.Request) {
        interactor?.fetchTopGames(request: request)
    }
    
    func updateListGames() {
        if let games = self.gamesViewModel?.games?.top {
            for game in games {
                self.listGames.append(game)
            }
            self.listGamesChangeable = self.listGames
        }
    }
    
    func callDeleteRequest() {
        self.middleLoading.startAnimating()
        self.collectionView.isHidden = true
        let request = TopGames.CoreData.Delete.Request()
        self.interactor?.deleteTopGamesInCoreData(request: request)
    }
    
    //MARK: Actions
    @IBAction func saveCoreDataAction(_ sender: Any) {
        
            let alert = UIAlertController.init(title: String.loc("OFFLINE_DATA_TITLE"), message: String.loc("OFFLINE_SAVE_DATA_TITLE_MESSAGE"), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: String.loc("CANCEL_MESSAGE"), style: UIAlertActionStyle.default, handler: { (action) in }))
        alert.addAction(UIAlertAction(title: String.loc("ACCEPT_MESSAGE"), style: UIAlertActionStyle.default, handler: { (action) in
                self.saveListProductsInCoreData()
            }))
            self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0),
                                          at: .top,
                                          animated: true)
        callDeleteRequest()
    }
    
    
    
    

}

//MARK: Search bar delegate
extension ListTopGamesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let filteredGames = self.listGames.filter { ($0?.game?.name.contains(searchText))! }
            self.listGamesChangeable = filteredGames
        } else {
            self.listGamesChangeable = self.listGames
            view.endEditing(true)
        }
        self.collectionView.reloadData()
    }
}


//MARK: Collection view Data Source Delegate
extension ListTopGamesViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ListTopGamesCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listGamesChangeable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let topGamesCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListTopGamesCell else {
            return UICollectionViewCell()
        }
        topGamesCell.delegate = self
        if self.listGamesChangeable.count > 0 {
            if let game = self.listGamesChangeable[indexPath.row]?.game {
                topGamesCell.setup(game: game, index: indexPath.row)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let game = self.listGamesChangeable[indexPath.row]{
            self.router?.routeToDetailTopGame(game: game)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y >= (collectionView.contentSize.height - collectionView.frame.size.height) {
            if bottomLoading.isAnimating == false && middleLoading.isAnimating == false {
                doFetchNextTopGames()
            }
            
        }
    }
    
    //MARK: Cell Delegate
    func imageDownloaded(image: String, index: Int) {
        self.listGames[index]?.game?.image = image
    }
}

//MARK: Display Logic Delegate
extension ListTopGamesViewController: ListTopGamesDisplayLogic {
    private func showInformation(text:String) {
        DispatchQueue.main.async {
            self.topInformationLabel.text = text
            self.topInformationViewHeight.constant = 30
            UIView.animate(withDuration: 0.4) {
                self.view.layoutIfNeeded()
            }
            let _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissInformation), userInfo: nil, repeats: false)
            
        }
    }
    @objc func dismissInformation() {
        self.topInformationLabel.text = ""
        self.topInformationViewHeight.constant = 0
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Core Data Methods
    func displaySavedUpdateTopGamesCoreData(viewModel: TopGames.CoreData.SaveUpdate.ViewModel) {
        showInformation(text: viewModel.alertMessage ?? "")
    }
    
    func displayFetchedTopGamesCoreData(viewModel: TopGames.CoreData.Fetch.ViewModel) {
        showInformation(text: viewModel.alertMessage ?? "")

        if let games = viewModel.games?.top {
            let title = String.loc("OFFLINE_DATA_TITLE")
            let message = String.loc("OFFLINE_DATA_TITLE_MESSAGE")
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: String.loc("CANCEL_MESSAGE"), style: UIAlertActionStyle.default, handler: { (action) in
                self.callDeleteRequest()
            }))
            alert.addAction(UIAlertAction(title: String.loc("ACCEPT_MESSAGE"), style: UIAlertActionStyle.default, handler: { (action) in
                self.listGames = games
                self.listGamesChangeable = self.listGames
                if let nextUrl = viewModel.games?._links.next {
                    self.nextUrlCoreData = nextUrl
                }
                self.collectionView.isHidden = false
                self.middleLoading.stopAnimating()
                self.collectionView.reloadData()
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            doFetchFirstTopGames()
        }
    }
    
    func displayDeletedTopGamesCoreData(viewModel: TopGames.CoreData.Delete.ViewModel) {
        showInformation(text: viewModel.alertMessage ?? "")
        self.listGames = [Games]()
        self.listGamesChangeable = self.listGames
        self.collectionView.reloadData()
        self.doFetchFirstTopGames()
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
                self.collectionView.reloadData()
                
            } else{
                if self.listGamesChangeable.count == 0 {
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
