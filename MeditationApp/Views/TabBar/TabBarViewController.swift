//
//  TabBarViewController.swift
//  MeditationApp
//
//  Created by Evgenii Kolgin on 08.09.2021.
//

import Lottie
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let animationView = AnimationView()
    
    private let customTabBar: CustomTabBar = {
        let tabBar = CustomTabBar()
        tabBar.backgroundColor = Colors.main.withAlphaComponent(0.5)
        tabBar.isHidden = true
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.main
        
        view.addSubview(customTabBar)
        customTabBar.delegate = self

        configureTabBar()
        
        setupAnimation()
    }
    
    func configureTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem(title: "", image: Images.homeButton, tag: 1)
        let soundsVC = UINavigationController(rootViewController: SoundsViewController())
        soundsVC.tabBarItem = UITabBarItem(title: "", image: Images.soundsButton, tag: 2)
        let timerVC = UINavigationController(rootViewController: TimerViewController())
        timerVC.tabBarItem = UITabBarItem(title: "", image: Images.timerButton, tag: 3)
        
        viewControllers = [homeVC, soundsVC, timerVC]
        
        tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        customTabBar.layer.cornerRadius = customTabBar.frame.size.height / 2
        customTabBar.clipsToBounds = true
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customTabBar.heightAnchor.constraint(equalToConstant: 50),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        view.bringSubviewToFront(customTabBar)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
}

extension TabBarViewController: CustomTabBarDelegate {
    func homeButtonTapped() {
        selectedIndex = 0
    }

    func soundsButtonTapped() {
        selectedIndex = 1
    }

    func timerButtonTapped() {
//        selectedIndex = 2
        let vc = UINavigationController(rootViewController: TimerViewController())
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - Animation LaunchScreen
extension TabBarViewController {

    private func setupAnimation() {
        animationView.animation = Animation.named("meditate")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }

    private func animate() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size

            self.animationView.frame = CGRect(x: -(diffX / 2), y: diffY / 2, width: size, height: size)
        }

        UIView.animate(withDuration: 1.5) {
            self.animationView.alpha = 0
        } completion: { done in
            if done {
                self.customTabBar.isHidden = false
            }
        }
    }
}
