//
//  ViewController.swift
//  MixApp
//
//  Created by Dastan Mambetaliev on 20/2/21.
//

import SideMenu
import UIKit

class ViewController: UIViewController, MenuControllerDelegate {

    private var sideMenu: SideMenuNavigationController?
//    создаем константы привязанные к контроллерам
    private let stopwatchController = StopwatchViewController()
    private let todolistController = TodolistTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuController(with: ["Home",
                                         "StopWatch",
                                         "Todolist"])
//        ???
        menu.delegate = self
//        ???
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
//для открытия меню с помощью свайпа
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        addChildControllers()
    }

//    ???
    private func addChildControllers() {
        addChild(stopwatchController)
        addChild(todolistController)
//        ???
        view.addSubview(stopwatchController.view)
        view.addSubview(todolistController.view)
        
        stopwatchController.view.frame = view.bounds
        todolistController.view.frame = view.bounds
        
        stopwatchController.didMove(toParent: self)
        todolistController.didMove(toParent: self)
        
        stopwatchController.view.isHidden = true
        todolistController.view.isHidden = true
    }
    
    @IBAction func didTapMenuButton(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    func didSelectMenuItem(named: String) {
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
//            меняем название текста сверху контроллера при переходе
            self?.title = named
            
            if named == "Home" {
                self?.stopwatchController.view.isHidden = true
                self?.todolistController.view.isHidden = true
            }
            else if named == "StopWatch" {
                self?.stopwatchController.view.isHidden = false
                self?.todolistController.view.isHidden = true
            }
            else if named == "Todolist" {
                self?.stopwatchController.view.isHidden = true
                self?.todolistController.view.isHidden = false
            }
            
        })
    }
}

