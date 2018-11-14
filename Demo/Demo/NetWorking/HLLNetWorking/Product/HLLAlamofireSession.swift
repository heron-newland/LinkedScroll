//
//  HLLAlamofireSession.swift
//  HLLNetWorking
//
//  Created by  bochb on 2017/12/25.
//  Copyright © 2017年 com.heron. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class HLLAlamofireSession: HLLSession {

    //自签名网站地址, 一般是域名+ip的数组
    let selfSignedHosts = [ "www.12333.com", "10.10.10.10"]
    
    override func session(urlString: String, method: HLLHTTPMethod, header: [String : String]?, parameter: [String : Any]?) {
        receiveChallenge()
        Alamofire.request(urlString, method:  HTTPMethod(rawValue: method.rawValue) ?? .get, parameters: parameter, encoding: URLEncoding.default, headers: header)
            .responseData { (response) in
                let responseProcessor = HLLNetResponseProcessor()
                responseProcessor.delegate = self.delegate
            switch response.result{
            case .success(let value):
                let result = try? JSON(data:value)
        responseProcessor.processResponse(response:result?.dictionaryObject )
            case .failure(let error):
                responseProcessor.processError(error: error)
            }
        }
    }
}

extension HLLAlamofireSession{
    
    func trustAll() {
          let manager = SessionManager.default
           manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //此处是一个例子, 直接信任所有证书
            return (URLSession.AuthChallengeDisposition.useCredential,
                    URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }

    /**
     一下另种验证方式任选其一
     */
    
     /// authentication
   /**
     **使用两个证书进行双向验证
     访问HTTPS服务需，需要安装“mykey.p12”，“tomcat.cer”这两个证书。同样，我们开发的应用中也需要把这两个证书添加进来。
 */
     func receiveChallenge() {
          let manager = SessionManager.default
        //认证相关设置
        
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust {
                print("服务端证书认证！")
                
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                //tomcat.cer路径
                let cerUrl = URL(fileURLWithPath:HLLNetConsistance.serveCerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
 
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                }
 

            }else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                 //认证客户端证书
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:IdentityAndTrust = HLLNetUtil.extractIdentity();
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            } else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    /**
     **只使用一个客户端证书
     由于我们使用的是自签名的证书，那么对服务器的认证全由客户端这边判断。也就是说其实使用一个客户端证书“mykey.p12”也是可以的（项目中也只需导入一个证书）。
     *当对服务器进行验证的时候，判断服务主机地址是否正确，是的话信任即可
 */
    func receiveChallengeByHost() {
        //认证相关设置
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器（这里不使用服务器证书认证，只需地址是我们定义的几个地址即可信任）
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust
                && self.selfSignedHosts.contains(challenge.protectionSpace.host) {
                print("服务器认证！")
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                return (.useCredential, credential)
            } else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:IdentityAndTrust = HLLNetUtil.extractIdentity();
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    
}


