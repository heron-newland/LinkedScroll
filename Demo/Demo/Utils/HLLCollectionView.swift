
//
//  HLLCollectionView.swift
//  Demo
//
//  Created by  bochb on 2018/11/12.
//  Copyright © 2018 com.heron. All rights reserved.
//

import UIKit
import MJRefresh

class HLLCollectionView: UICollectionView {

    var loadNewData:((HLLCollectionView) -> Void)?
    var loadMoreData:((HLLCollectionView) -> Void)?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    
    /// 配置collectionview的公共方法
    private func configureCollectionView(){
        
    }
}

extension HLLCollectionView {
    private func configureRefresh(){
        let refreshHeader =   MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNew))
        mj_header = refreshHeader
    }
    private func configureLoadMore(){
        let refreshFooter =  MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMore))
        mj_footer = refreshFooter
    }
    
    
    @objc  open func loadNew() {
        guard let loadNewData = loadNewData else {
            sleep(1)
            mj_header.endRefreshing()
            return
        }
        loadNewData(self)
    }
    
    @objc open func loadMore() {
        guard let loadMoreData = loadMoreData else {
            sleep(1)
            mj_footer.endRefreshing()
            return
        }
        loadMoreData(self)
    }
    
    
    //MARK: - public
    open func shouldPullRefresh(shouldPullRefresh: Bool){
        if shouldPullRefresh {
            configureRefresh()
        }else{
            mj_header = nil
        }
    }
    open func shouldPullLoadMore(shouldPullLoadMore:Bool){
        if shouldPullLoadMore {
            configureLoadMore()
        }else{
            mj_footer = nil
        }
    }
}
