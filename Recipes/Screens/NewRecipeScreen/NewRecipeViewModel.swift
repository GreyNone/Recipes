//
//  NewRecipeViewModel.swift
//  Recipes
//
//  Created by Александр Василевич on 31.01.24.
//

import Foundation

final class NewRecipeViewModel {
    
    weak var delegate: NewRecipeViewModelDelegate?
    var ingredients = [Ingredient]()
    var steps = [Step]()
    var tableViewData: [(TableViewCellTypes,String?)] = [
        (TableViewCellTypes.addImageTableViewCell,nil),
        (TableViewCellTypes.addTitleTableViewCell,nil),
        (TableViewCellTypes.addPriceTableViewCell,nil),
        (TableViewCellTypes.addDescriptionTableViewCell,nil),
        (TableViewCellTypes.ingredientsCollectionView,nil),
        (TableViewCellTypes.addStepTableViewCell,nil)
    ]
}

//MARK: - UITableViewDataSource
enum TableViewCellTypes: String {
    case addImageTableViewCell
    case addTitleTableViewCell
    case addPriceTableViewCell
    case addDescriptionTableViewCell
    case ingredientsCollectionView
    case addStepTableViewCell
    case stepTableViewCell //repetitive cell
}

extension NewRecipeViewModel {
    var numberOfRows: Int {
        return tableViewData.count
    }
    
    func addNewStep() {
        let newStep = Step(number: steps.count + 1, step: nil)
        steps.append(newStep)
        tableViewData.append((TableViewCellTypes.stepTableViewCell,"Step \(steps.count)"))
        
        let indexPath = IndexPath(item: self.tableViewData.count - 1, section: 0)
        delegate?.insertNewElementInTableView(at: indexPath)
    }
    
    func removeStep(at indexPath: IndexPath?) {
        if let indexPath = indexPath {
            let uniqueCellsCount = tableViewData.filter { (cellType,value) in
                cellType != .stepTableViewCell
            }.count //counting the amount of unique cells(without repetitive stepTableViewCell)
            
            steps.remove(at: indexPath.row - uniqueCellsCount)
            tableViewData.remove(at: indexPath.row)
            
            updateStepAfterRemoval() //updating step number after removal and updating tableViewData's 
            
            delegate?.removeElementFromTableView(at: indexPath)
            delegate?.updateCellTitles(at: createIndexPathsToUpdate(uniqueCellsCount: uniqueCellsCount))
        }
    }
    
    private func updateStepAfterRemoval() {
        guard !steps.isEmpty else { return }
        
        for i in 0...steps.count - 1 {
            steps[i].number = i + 1
        }
        
        var i = 0
        tableViewData = tableViewData.map { cell in
            if cell.0 == .stepTableViewCell {
                i += 1
                return (TableViewCellTypes.stepTableViewCell, "Step \(i)")
            }
            
            return cell
        }
    }
    
    private func createIndexPathsToUpdate(uniqueCellsCount: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for step in steps {
            let indexPath = IndexPath(row: (steps.firstIndex(of: step) ?? 0) + uniqueCellsCount, section: 0)
            indexPaths.append(indexPath)
        }
        
        return indexPaths
    }
}

//MARK: - UICollectionViewDataSource
extension NewRecipeViewModel {
    var numberOfItems: Int {
        return ingredients.count + 1
    }
}

//MARK: - UICollectionViewDelegate
extension NewRecipeViewModel {
    func addNewIngredient() {
        let newIngredient = Ingredient()
        ingredients.append(newIngredient)
        
        let indexPath = IndexPath(item: self.ingredients.count - 1, section: 0)
        delegate?.insertNewElementInCollectionView(at: indexPath)
    }
    
    func removeIngredient(at indexPath: IndexPath?) {
        if let indexPath = indexPath {
            ingredients.remove(at: indexPath.row)
            delegate?.removeElementFromCollectionView(at: indexPath)
        }
    }
}
