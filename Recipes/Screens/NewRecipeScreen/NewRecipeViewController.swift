//
//  NewRecipeViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 19.10.23.
//

import UIKit
import PhotosUI

class NewRecipeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var newRecipeViewModel: NewRecipeViewModel?
    weak var ingredientsCollectionViewReference: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Create Your Own Recipe"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = nil
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setup() {
        self.newRecipeViewModel = NewRecipeViewModel()
        self.newRecipeViewModel?.delegate = self
        
        navigationBarSetup()
        tableViewSetup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func navigationBarSetup() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(named: "mainColor")
        
        let saveButtonBarItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didClickOnSaveButton))
        saveButtonBarItem.tintColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = saveButtonBarItem
    }
    
    private func tableViewSetup() {
        tableView.register(AddImageTableViewCell.nib, forCellReuseIdentifier: AddImageTableViewCell.identifier)
        tableView.register(AddGeneralInfoTableViewCell.nib, forCellReuseIdentifier: AddGeneralInfoTableViewCell.identifier)
        tableView.register(AddDescriptionTableViewCell.nib, forCellReuseIdentifier: AddDescriptionTableViewCell.identifier)
        tableView.register(CollectionViewTableViewCell.nib, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableView.register(AddStepTableViewCell.nib, forCellReuseIdentifier: AddStepTableViewCell.identifier)
        tableView.register(StepTableViewCell.nib, forCellReuseIdentifier: StepTableViewCell.identifier)
    }
    
    //MARK: - Actions
    @objc private func didClickOnSaveButton(_ sender: UIBarButtonItem) {
        
    }
    
    //MARK: - KeyboardNotificationSelectors
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            tableView.contentInset = contentInsets
            tableView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

//MARK: - NewRecipeViewModelDelegate
extension NewRecipeViewController: NewRecipeViewModelDelegate {
    func insertNewElementInCollectionView(at indexPath: IndexPath) {
        ingredientsCollectionViewReference?.performBatchUpdates({ [weak self] in
            self?.ingredientsCollectionViewReference?.insertItems(at: [indexPath])
        })
    }
    
    func removeElementFromCollectionView(at indexPath: IndexPath) {
        ingredientsCollectionViewReference?.performBatchUpdates({ [weak self] in
            self?.ingredientsCollectionViewReference?.deleteItems(at: [indexPath])
        })
    }
    
    func insertNewElementInTableView(at indexPath: IndexPath) {
        tableView.performBatchUpdates { [weak self] in
            self?.tableView.insertRows(at: [indexPath], with: .left)
        }
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func removeElementFromTableView(at indexPath: IndexPath) {
        tableView.performBatchUpdates { [weak self] in
            self?.tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    func updateCellTitles(at indexPaths: [IndexPath]) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.performBatchUpdates({
                self?.tableView.reloadRows(at: indexPaths, with: .automatic)
            })
        }
    }
}

//MARK: - TableViewCellDelegate
extension NewRecipeViewController: TableViewCellDelegate {
    
    func updateTableView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tableView.performBatchUpdates(nil)
        }
    }
    
    func presentZoomViewController(with image: UIImage) {
        guard let addTitleTableViewCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? AddGeneralInfoTableViewCell else { return }
        
        let zoomViewControllerStoryboard = UIStoryboard(name: "ZoomViewController", bundle: nil)
        if let zoomViewController = zoomViewControllerStoryboard.instantiateViewController(withIdentifier: "ZoomViewController") as? ZoomViewController {
            zoomViewController.imageToShow = image
            zoomViewController.titleToShow = addTitleTableViewCell.textField.text
//            self.navigationController?.pushViewController(zoomViewController, animated: true)
            self.present(zoomViewController,animated: true)
        }
    }
    
    func presentController(controller: UIViewController) {
        self.present(controller, animated: true)
    }
    
    func dismissController() {
        self.dismiss(animated: true)
    }
    
    func removeItemFromCollectionView(item: AddIngredientCollectionViewCell) {
        newRecipeViewModel?.removeIngredient(at: ingredientsCollectionViewReference?.indexPath(for: item))
    }
    
    func removeItemFromTableView(item: UITableViewCell) {
        newRecipeViewModel?.removeStep(at: tableView.indexPath(for: item))
    }
}

//MARK: - UITableViewDataSource
extension NewRecipeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newRecipeViewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch newRecipeViewModel?.tableViewData[indexPath.row].0 {
        case .addImageTableViewCell:
            guard let addImageTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddImageTableViewCell.identifier)
                    as? AddImageTableViewCell else { return UITableViewCell() }
        
            addImageTableViewCell.delegate = self
            
            return addImageTableViewCell
        case .addTitleTableViewCell:
            guard let addTitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddGeneralInfoTableViewCell.identifier)
                    as? AddGeneralInfoTableViewCell else { return UITableViewCell() }
            
            addTitleTableViewCell.configure(with: "Add A Title to Your Recipe", textFieldPlaceholder: "Your Title")
            
            return addTitleTableViewCell
        case .addPriceTableViewCell:
            guard let addPriceTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddGeneralInfoTableViewCell.identifier)
                    as? AddGeneralInfoTableViewCell else { return UITableViewCell() }
            
            addPriceTableViewCell.configure(with: "Add Price to Your Recipe", textFieldPlaceholder: "Your Price")
            
            return addPriceTableViewCell
        case .addDescriptionTableViewCell:
            guard let addDescriptionTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddDescriptionTableViewCell.identifier)
                    as? AddDescriptionTableViewCell else {  return UITableViewCell() }
            
            addDescriptionTableViewCell.delegate = self
            
            return addDescriptionTableViewCell
        case .ingredientsCollectionView:
            guard let collectionViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier)
                    as? CollectionViewTableViewCell else { return UITableViewCell() }
            
            collectionViewTableViewCell.ingredientsCollectionView.dataSource = self
            collectionViewTableViewCell.ingredientsCollectionView.delegate = self
            ingredientsCollectionViewReference = collectionViewTableViewCell.ingredientsCollectionView
            
            return collectionViewTableViewCell
        case .addStepTableViewCell:
            guard let addStepTableViewCell = tableView.dequeueReusableCell(withIdentifier: AddStepTableViewCell.identifier)
                    as? AddStepTableViewCell else { return UITableViewCell() }
            
            return addStepTableViewCell
        case .stepTableViewCell:
            guard let stepTableViewCell = tableView.dequeueReusableCell(withIdentifier: StepTableViewCell.identifier)
                    as? StepTableViewCell else { return UITableViewCell() }
            
            stepTableViewCell.titleLabel.text = newRecipeViewModel?.tableViewData[indexPath.row].1
            stepTableViewCell.delegate = self
            
            return stepTableViewCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

//MARK: - UITableViewDelegate
extension NewRecipeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch newRecipeViewModel?.tableViewData[indexPath.row].0 {
        case .addStepTableViewCell:
            newRecipeViewModel?.addNewStep()
        default:
            break
        }
    }
    
}

//MARK: - UICollectionViewDataSource
extension NewRecipeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newRecipeViewModel?.numberOfItems ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case (newRecipeViewModel?.ingredients.count ?? 0):
            guard let addNewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewCellCollectionViewCell.identifier,
                                                                                        for: indexPath)
                    as? AddNewCellCollectionViewCell else { return UICollectionViewCell() }
            
            return addNewCellCollectionViewCell
        default:
            guard let addIngredientCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddIngredientCollectionViewCell.identifier,
                                                                                              for: indexPath)
                    as? AddIngredientCollectionViewCell else { return UICollectionViewCell() }
            
            addIngredientCollectionViewCell.delegate = self
            
            return addIngredientCollectionViewCell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension NewRecipeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case (newRecipeViewModel?.ingredients.count ?? 0):
            newRecipeViewModel?.addNewIngredient()
        default:
            break
        }
    }
}
