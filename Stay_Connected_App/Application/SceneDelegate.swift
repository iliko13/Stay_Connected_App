import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let isLoggedIn = KeychainHelper.getAccessToken() != nil
        
        if isLoggedIn {
            window.rootViewController = UINavigationController(rootViewController: TabBarController())
        } else {
            window.rootViewController = UINavigationController(rootViewController: LoginVC())
        }

        self.window = window
        self.window?.makeKeyAndVisible()
    }

}

