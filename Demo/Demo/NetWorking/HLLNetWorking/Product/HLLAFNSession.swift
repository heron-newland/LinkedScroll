//
//  HLLAFNSession.swift
//  HLLNetWorking
//
//  Created by  bochb on 2017/12/25.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking
class HLLAFNSession: HLLSession {

    override func session(urlString: String, method: HLLHTTPMethod, header: [String : String]?, parameter: [String : Any]?) {
        guard let url = URL(string: urlString) else { return }
        let request =  URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 12)
        let sessionConfigure =  URLSessionConfiguration.default
        let sessionManager =  AFURLSessionManager(sessionConfiguration: sessionConfigure)
        sessionManager.securityPolicy = trusetAll()
//        sessionManager.securityPolicy = customSecurityPolicy()
        
        let task =  sessionManager.dataTask(with: request, uploadProgress: { (progress) in
            debugPrint("uploadProgress: \(progress.fractionCompleted)")
        }, downloadProgress: { (progress) in
            debugPrint("downloadProgress: \(progress.fractionCompleted)")
        }) { (urlResponse, data, error) in
            let json = data as? Dictionary<String, Any>
            let responseProcessor = HLLNetResponseProcessor()
            responseProcessor.delegate = self.delegate
            if (error != nil) {
                responseProcessor.processError(error: error!)
            }else{
                responseProcessor.processResponse(response: json)
            }
        }
        task.resume()
    }
}

extension HLLAFNSession{
    
    /// 不校验证书
    ///
    /// - Returns: 
    func trusetAll() -> AFSecurityPolicy {
      let securityPolicy =  AFSecurityPolicy(pinningMode: .none)
        securityPolicy.allowInvalidCertificates = true
         securityPolicy.validatesDomainName = false
        return securityPolicy
    }
    
    // https ssl 验证函数
    func customSecurityPolicy() -> AFSecurityPolicy{
        
        // 先导入证书 证书由服务端生成，具体由服务端人员操作
        let cerData = try! Data(contentsOf: URL(fileURLWithPath: HLLNetConsistance.serveCerPath))
        // AFSSLPinningModeCertificate 使用证书验证模式
        let securityPolicy =  AFSecurityPolicy(pinningMode: .certificate)
        // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
        // 如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = true
        
        //validatesDomainName 是否需要验证域名，默认为YES;
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
        //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        //如置为NO，建议自己添加对应域名的校验逻辑。
        securityPolicy.validatesDomainName = false
        
        securityPolicy.pinnedCertificates = NSSet(object: cerData) as? Set<Data>
        
        return securityPolicy
    }
}

