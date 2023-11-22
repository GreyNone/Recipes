//
//  ViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private var upperLineView: UIView!
    private let spacing: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.addTabbarIndicatorView(index: 0, isFirstTime: true)
        }
        
        tabBar.tintColor = UIColor(named: "mainColor")
        delegate = self
        
        let homeViewControllerStoryboard = UIStoryboard(name: "HomeViewControllerStoryboard", bundle: nil)
        let homeViewController = homeViewControllerStoryboard.instantiateViewController(withIdentifier: "HomeViewController")
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        
        let newRecipeViewControllerStoryboard = UIStoryboard(name: "NewRecipeViewControllerStoryboard", bundle: nil)
        let newRecipeViewController = newRecipeViewControllerStoryboard.instantiateViewController(identifier: "NewRecipeViewController")
        let newRecipeNavigationController = UINavigationController(rootViewController: newRecipeViewController)
        
        let favouritesViewControllerStoryboard = UIStoryboard(name: "FavouritesViewControllerStoryboard", bundle: nil)
        let favouritesViewController = favouritesViewControllerStoryboard.instantiateViewController(withIdentifier: "FavouritesViewController")
        let favouritesNavigationController = UINavigationController(rootViewController: favouritesViewController)
        
        homeNavigationController.tabBarItem = UITabBarItem(title: "Recipes",
                                                           image: UIImage(systemName: "house"),
                                                           selectedImage: UIImage(systemName: "house.fill"))
        newRecipeViewController.tabBarItem = UITabBarItem(title: nil,
                                                          image: UIImage(systemName: "plus.app"),
                                                          selectedImage: nil)
        favouritesViewController.tabBarItem = UITabBarItem(title: "Favourite Recipes",
                                                           image: UIImage(systemName: "heart"),
                                                           selectedImage: UIImage(systemName: "heart.fill"))

        self.setViewControllers([homeNavigationController,newRecipeNavigationController,favouritesNavigationController], animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
//        let appereance = UITabBarAppearance()
//        appereance.backgroundColor = .clear
//        
//        tabBar.standardAppearance = appereance
//        tabBar.scrollEdgeAppearance = appereance
    }
    
    private func addTabbarIndicatorView(index: Int, isFirstTime: Bool = false){
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        
        if !isFirstTime{
            upperLineView.removeFromSuperview()
        }
        
        upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing,
                                             y: tabView.frame.minY + 0.1,
                                             width: tabView.frame.size.width - spacing * 2,
                                             height: 2))
        upperLineView.backgroundColor = UIColor(named: "mainColor")
        
        tabBar.addSubview(upperLineView)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addTabbarIndicatorView(index: self.selectedIndex)
    }
}

