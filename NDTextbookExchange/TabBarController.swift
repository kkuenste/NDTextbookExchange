//
//  TabBarController.swift
//  NDTextbookExchange
//
//  Created by Katie Kuenster on 3/9/17.
//  Copyright © 2017 CSE40814. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = #colorLiteral(red: 0.7249842286, green: 0.8416147828, blue: 0.8822570443, alpha: 1)
        self.tabBar.isTranslucent = false
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSFontAttributeName:UIFont(name: "Helvetica Neue", size: 14)]
        appearance.setTitleTextAttributes(attributes, for: .normal)

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
