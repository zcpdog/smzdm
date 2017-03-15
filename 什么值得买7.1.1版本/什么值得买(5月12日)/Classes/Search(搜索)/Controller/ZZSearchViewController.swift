//
//  ZZSearchViewController.swift
//  什么值得买
//
//  Created by Wang_ruzhou on 2016/12/26.
//  Copyright © 2016年 Wang_ruzhou. All rights reserved.
//

import UIKit

class ZZSearchViewController: ZZSecondBaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let margin: CGFloat = 15
        let inset = kZDMPadding * 1.0
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.headerReferenceSize = CGSize.init(width: kScreenWidth, height: 40)
        flowLayout.sectionInset = UIEdgeInsets.init(top: inset * 0.7, left: 0, bottom: inset * 0.7, right: 0)
        
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets.init(top: inset, left: inset, bottom: 0, right: inset)
        collectionView.registerReuseCellClass(ZZSearchItem.self)
        collectionView.registerReuseSectionHeaderViewClass(ZZSearchHeader.self)
        return collectionView
    }()
    
    lazy var textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "家用电器"
        let scopeView = UIImageView.init(image: #imageLiteral(resourceName: "homePage_searchIcon"))
        scopeView.contentMode = .center
        scopeView.width = 30
        textFiled.leftView = scopeView
        textFiled.leftViewMode = .always
        textFiled.width = kScreenWidth - 100
        textFiled.height = 32
        textFiled.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        textFiled.layer.cornerRadius = 2.0
        textFiled.clipsToBounds = true
        textFiled.clearButtonMode = .whileEditing
        textFiled.returnKeyType = .search
        textFiled.tintColor = UIColor.blue
        return textFiled
    }()
    
    lazy var searchRequest: ZZSearchRequest = {
        let searchRequest = ZZSearchRequest()
        return searchRequest
    }()
    
    lazy var dataSoucre: [ZZSearchModel] = {
        let dataSoucre = [ZZSearchModel]();
        return dataSoucre
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
        loadData()
        textFiled.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ZZSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return dataSoucre.count
        }
        return dataSoucre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ZZSearchItem.self), for: indexPath) as! ZZSearchItem
        cell.searchModel = dataSoucre[indexPath.item];
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseableView: ZZSearchHeader!
        
        if kind == UICollectionElementKindSectionHeader {
            reuseableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(ZZSearchHeader.self), for: indexPath) as! ZZSearchHeader
            if indexPath.section == 0 {
                reuseableView.backgroundColor = kGlobalLightGrayColor
                reuseableView.titleLabel.text = "全站热门搜索"
                reuseableView.clearBtn.isHidden = true
            } else {
                reuseableView.titleLabel.text = "搜索历史"
                reuseableView.clearBtn.isHidden = false
            }
            
        }
        
        return reuseableView
    }
}

extension ZZSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let title = self.dataSoucre[indexPath.item].title as NSString?{
            let height: CGFloat = 30
            let width = title.width(for: UIFont.systemFont(ofSize: 14)) + 20
            return CGSize.init(width: width, height: height)
        }
        
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ZZSearchViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    override func setupNav() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancelBtnDidClick))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: textFiled)
        
        
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    
        
    }
    
    func loadData() {
        ZZAPPDotNetAPIClient.shared().get(searchRequest) { (responseObj, error) in
            if let responseObj = responseObj as? [AnyHashable: Any]{
                if let rows = responseObj["rows"] as? [Any]{
                    self.dataSoucre = NSArray.modelArray(with: ZZSearchModel.self, json: rows) as! [ZZSearchModel]
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
}

extension ZZSearchViewController {
    
    func cancelBtnDidClick() {
        
        dismiss(animated: false, completion: nil)
    }
    
}
