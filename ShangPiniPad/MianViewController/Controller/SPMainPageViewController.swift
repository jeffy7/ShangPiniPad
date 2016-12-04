//
//  SPMainPageViewController.swift
//  ShangPiniPad
//
//  Created by je_ffy on 2016/12/4.
//  Copyright © 2016年 je_ffy. All rights reserved.
//

import UIKit
import Alamofire

class SPMainPageViewController: SPViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var collectionView = UICollectionView(frame:CGRect(x:0,y:0,width:0,height:0), collectionViewLayout: UICollectionViewFlowLayout())
    var dataArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        let layout = UICollectionViewFlowLayout();
        
        layout.scrollDirection = UICollectionViewScrollDirection.vertical;
        layout.itemSize = CGSize(width:50,height:50)
        //垂直方向间距
        layout.minimumInteritemSpacing = 10;
        //水平方向间距
        layout.minimumLineSpacing = 10;
        //设置四周得边缘距离
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        collectionView = UICollectionView.init(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(SPMainPageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :SPMainPageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SPMainPageCollectionViewCell
        cell.backgroundColor = UIColor.red
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(5, 10, 5, 10)
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
