//
//  FilterViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 26.10.23.
//

import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    private var filterViewModel = FilterViewModel()
    weak var delegate: FilterDataProtocol?
    
    //MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.register(FilterTableViewCell.nib, forCellReuseIdentifier: FilterTableViewCell.identifier)
    }
    
    @IBAction func didTapOnCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterViewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let filterTableViewCell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier)
                as? FilterTableViewCell else { return FilterTableViewCell() }
        filterTableViewCell.setupTableViewCell(data: filterViewModel.getInfo(for: indexPath))
        return filterTableViewCell
    }
}

//MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let filterTableViewCell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        filterTableViewCell.updateTableViewCell(for: indexPath, isChecked: filterViewModel.isCheckedState(for: indexPath))
        filterViewModel.isCheckUpdate(for: indexPath)
        
        delegate?.perfomUpdates()
    }
}
