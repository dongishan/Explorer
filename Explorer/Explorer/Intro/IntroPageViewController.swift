//
//  IntroPageViewController.swift
//  MRT-CW1
//
//  Created by Gishan Don Ranasinghe on 05/03/2017.
//  Copyright © 2017 Gishan Don Ranasinghe. All rights reserved.
//

import UIKit

class IntroPageViewController: UIPageViewController {

    weak var introDelegate: IntroPageViewControllerDelegate?
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newIntroViewController("Intro1"),
                self.newIntroViewController("Intro2"),
                self.newIntroViewController("Intro3")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let initialViewController = orderedViewControllers.first {
            scrollToViewController(initialViewController)
        }
        
        introDelegate?.tutorialPageViewController(self,
                                                     didUpdatePageCount: orderedViewControllers.count)
    }
    
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = orderedViewControllers.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = orderedViewControllers[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
    fileprivate func newIntroViewController(_ introId: String) -> UIViewController {
        return UIStoryboard(name: "Intro", bundle: nil) .
            instantiateViewController(withIdentifier: "\(introId)ViewController")
    }
    
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                            direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                        
                            self.notifyIntroDelegateOfNewIndex()
        })
    }
    
    fileprivate func notifyIntroDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = orderedViewControllers.index(of: firstViewController) {
            introDelegate?.tutorialPageViewController(self,
                                                         didUpdatePageIndex: index)
        }

    }
    
}

// MARK: UIPageViewControllerDataSource

extension IntroPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}

extension IntroPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyIntroDelegateOfNewIndex()
    }
    
}

protocol IntroPageViewControllerDelegate: class {
    
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController,
                                    didUpdatePageCount count: Int)
    func tutorialPageViewController(_ tutorialPageViewController: IntroPageViewController,
                                    didUpdatePageIndex index: Int)
}
