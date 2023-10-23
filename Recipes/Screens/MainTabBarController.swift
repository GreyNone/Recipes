//
//  ViewController.swift
//  Recipes
//
//  Created by Александр Василевич on 18.10.23.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home",
                                                           image: UIImage(systemName: "house"),
                                                           selectedImage: UIImage(systemName: "house.fill"))
        newRecipeViewController.tabBarItem = UITabBarItem(title: nil,
                                                          image: nil,
                                                          selectedImage: nil)
        favouritesViewController.tabBarItem = UITabBarItem(title: "Favourites",
                                                           image: UIImage(systemName: "heart"),
                                                           selectedImage: UIImage(systemName: "heart.fill"))

        self.setViewControllers([homeNavigationController,newRecipeNavigationController,favouritesNavigationController], animated: false)
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapOnButton = { [weak self] in
            self?.createNewController()
        }
    }
    
    private func createNewController() {
        let newRecipeViewControllerStoryboard = UIStoryboard(name: "NewRecipeViewControllerStoryboard", bundle: nil)
        let newRecipeViewController = newRecipeViewControllerStoryboard.instantiateViewController(identifier: "NewRecipeViewController")
        let newRecipeNavigationController = UINavigationController(rootViewController: newRecipeViewController)
//        newRecipeViewController.modalPresentationStyle
        self.present(newRecipeNavigationController, animated: true)
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        if selectedIndex == 1 {
            return false
        }
        
        return true
    }
}

