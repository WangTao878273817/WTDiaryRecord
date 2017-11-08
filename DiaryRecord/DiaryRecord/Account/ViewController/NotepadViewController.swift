//
//  NotepadViewController.swift
//  DiaryRecord
//
//  Created by Mac on 2017/11/7.
//  Copyright © 2017年 WT. All rights reserved.
//

import UIKit

class NotepadViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configViewCotroller()
    }
    
    ///设置页面
    func configViewCotroller(){
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -UICollectionView Delegate And DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifyStr : String = "NotepadCell"
        let cell : NotepadCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifyStr, for: indexPath) as! NotepadCollectionViewCell
        cell.layer.borderColor = UIColor.init(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1).cgColor
        cell.pageNameLab.text = "小计本书"
        
        return cell
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
