//
//  HomeViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var emptyStatusView: EmptyStatusView?
    private var homeViewModel: HomeViewModel?
    private var isShowingView = false
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Food Recipes For You"
        isShowingView = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isShowingView = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShowingView {
            recipesCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func setup() {
        self.homeViewModel = HomeViewModel()
        self.homeViewModel?.delegate = self
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "mainColor")
        recipesCollectionView.register(RecipeCollectionViewCell.nib, forCellWithReuseIdentifier: RecipeCollectionViewCell.identifier)
        self.homeViewModel?.loadData()
    }
    
    //MARK: - IBActions
    @IBAction func didTapOnFilterButton(_ sender: Any) {
        let filterViewStoryboard = UIStoryboard(name: "FilterViewStoryboard", bundle: nil)
        let filterViewController = filterViewStoryboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        filterViewController.delegate = self
        if let sheetPresentationController = filterViewController.sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
        }
        self.present(filterViewController, animated: true)
    }
}

//MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    
    func updateCollectionView() {
        recipesCollectionView.reloadData()
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func presentEmptyStatusView() {
        emptyStatusView = EmptyStatusView()
        if let emptyStatusView = emptyStatusView {
            view.addSubview(emptyStatusView)
            emptyStatusView.delegate = self
            addConsraintsToEmptyStatusView()
        }
    }
    
    func dismissEmptyStatusView() {
        emptyStatusView?.removeFromSuperview()
        emptyStatusView = nil
    }
}

//MARK: - EmptyStatusView
extension HomeViewController: EmptyStatusViewProtocol {
    
    private func addConsraintsToEmptyStatusView() {
        if let emptyStatusView = emptyStatusView {
            emptyStatusView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyStatusView.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                emptyStatusView.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                emptyStatusView.containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                emptyStatusView.containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
    }
    
    func didTapOnButton() {
        homeViewModel?.didTapOnButton()
    }
}

//MARK: - FilterDataProtocol
extension HomeViewController: FilterDataDelegate {
    func perfomUpdates() {
        homeViewModel?.filterData()
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let numberOfItems = homeViewModel?.numberOfItems else { return 0 }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let recipeCollectonViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identifier,
                                                                                for: indexPath)
                as? RecipeCollectionViewCell else { return RecipeCollectionViewCell() }
        
        if let homeViewModel = homeViewModel {
            recipeCollectonViewCell.setupCollectionViewCell(data: homeViewModel.getInfo(for: indexPath))
        }
        
        return recipeCollectonViewCell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        homeViewModel?.calculateItemWidth(collectionWidth: self.recipesCollectionView.frame.width) ?? CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return homeViewModel?.insets ?? UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return homeViewModel?.minimumLineSpacingForSection ?? 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return homeViewModel?.minimumInteritemSpacingForSection ?? 10
    }
}

//MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(DetailViewController.makeDetailViewController(recipe: homeViewModel?.selectedRecipe(indexPath: indexPath)), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        homeViewModel?.loadIfNeeded(for: indexPath)
    }
}

