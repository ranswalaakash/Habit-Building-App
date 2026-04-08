//
//  OnboardingContentVC.swift
//  habitSignIn
//
//  Created by GEU on 28/03/26.
//

import UIKit
class OnboardingContentVC: UIViewController {
    @IBAction func skipTapped(_ sender: UIButton) {
           UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
           goToLogin()
       }
    @IBAction func getStartedTapped(_ sender: UIButton) {
        goToLogin()
    }

    func goToLogin() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return
        }

        let storyboard = UIStoryboard(name: "LoginScreens", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "LoginNavVC")

        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
}
