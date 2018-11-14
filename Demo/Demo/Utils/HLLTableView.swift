//
//  HLLTableView.swift
//  Demo
//
//  Created by  bochb on 2018/11/12.
//  Copyright © 2018 com.heron. All rights reserved.
//

import UIKit
import MJRefresh

class HLLTableView: UITableView {

    var loadNewData:(() -> Void)?
    var loadMoreData:(() -> Void)?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    //对所有tableview的公共配置
    private func configureTableView() {
        
    }
    

}

// MARK: - configure refresher
extension HLLTableView{
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
        loadNewData()
    }
    
    @objc open func loadMore() {
        guard let loadMoreData = loadMoreData else {
            sleep(1)
            mj_footer.endRefreshing()
            return
        }
        loadMoreData()
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
