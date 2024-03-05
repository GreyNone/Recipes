//
//  ZoomViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 14.02.24.
//

import UIKit

class ZoomViewController: UIViewController {

    @IBOutlet weak var zoomScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    var imageToShow: UIImage?
    var titleToShow: String?
    private var isHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setup() {
        zoomScrollView.minimumZoomScale = 1.0
        zoomScrollView.maximumZoomScale = 3.0
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction)))
        
        imageView.image = imageToShow
        titleLabel.text = titleToShow
    }
    
    //MARK: - Actions
    @IBAction func didTapOnCloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @objc func tapGestureRecognizerAction(_ sender: UITapGestureRecognizer) {
        updateViews()
    }
    
    private func updateViews() {
        UIView.transition(with: footerView,
                          duration: 0.3,
                          options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            
            self.footerView.isHidden = self.isHidden
        } completion: { [weak self] success in
            guard let self = self else { return }
            
            if success {
                self.isHidden = !self.isHidden
            }
        }
    }
}

extension ZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
