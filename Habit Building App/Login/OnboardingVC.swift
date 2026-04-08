//
//  OnboardingContentVC.swift
//  habitSignIn
//
//  Created by GEU on 27/03/26.
//

import UIKit

class OnboardingVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var pageVC: UIPageViewController!
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1. Load PageViewController
        guard let pageVC = storyboard?.instantiateViewController(withIdentifier: "OnboardingPageVC") as? UIPageViewController else {
            print("PageVC not found")
            return
        }

        self.pageVC = pageVC

        pageVC.dataSource = self
        pageVC.delegate = self

        // 2. Load screens
        guard let screen1 = storyboard?.instantiateViewController(withIdentifier: "screen1"),
              let screen2 = storyboard?.instantiateViewController(withIdentifier: "screen2"),
              let screen3 = storyboard?.instantiateViewController(withIdentifier: "screen3")
                else {
            print("Screens not found")
            return
        }

        pages = [screen1,screen2,screen3]

        // 3. Set first screen
        pageVC.setViewControllers([pages[0]], direction: .forward, animated: true)

        // 4. Add PageVC inside OnboardingVC
        addChild(pageVC)
        view.addSubview(pageVC.view)

        // IMPORTANT: full screen layout
        pageVC.view.frame = view.bounds

        pageVC.didMove(toParent: self)
    }
  
    // MARK: Swipe Logic

    func pageViewController(_ pageViewController: UIPageViewController,
                           viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = pages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                           viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else {
            return nil
        }
        return pages[index + 1]
    }
}
