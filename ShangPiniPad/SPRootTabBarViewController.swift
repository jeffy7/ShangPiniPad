//
//  SPRootTabBarViewController.swift
//  ShangPiniPad
//
//  Created by je_ffy on 2016/11/26.
//  Copyright © 2016年 je_ffy. All rights reserved.
//

import UIKit

class SPRootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubController()

        self.setUpItem()
        // Do any additional setup after loading the view.
        
        
    }
    
    func setUpSubController() {
        let mainPageNav = UINavigationController.init(rootViewController: SPMainPageViewController.init())
        let catrgoryNav = UINavigationController.init(rootViewController: SPCategoryViewController.init())
        let activityNav = UINavigationController.init(rootViewController: SPActivityViewController.init())
        let brandNav = UINavigationController.init(rootViewController: SPBrandViewController.init())
        let mineNav = UINavigationController.init(rootViewController: SPMineViewController.init())
        
        self.viewControllers = [mainPageNav,catrgoryNav,activityNav,brandNav,mineNav]
    }
    
    func setUpItem()  {
        
        var normalImageArray = ["nav_mall","nav_finding","nav_classification","nav_icon_shopping-cart","nav_mine"]
        var selectedImageArray = ["nav_mall_press","nav_finding_press","nav_classification_press","nav_icon_shopping-cart_press","nav_mine_press"]
        
        
        for i in 0 ..< (self.tabBar.items?.count)! {
            let normalImage = UIImage.init(named: normalImageArray[i])
            let selectedImage = UIImage.init(named: selectedImageArray[i])
            
            
            let item = self.tabBar.items?[i]
            item?.image = normalImage
            item?.selectedImage = selectedImage
            
            
        }
    }

    func doAnything() {
        print("button Tap")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
