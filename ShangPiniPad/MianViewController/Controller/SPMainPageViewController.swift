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
        
        self.requestData()
        
        
        // Do any additional setup after loading the view.
    }
    func requestData() {
        
        //认证相关设置
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust {
                print("服务端证书认证！")
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = Bundle.main.path(forResource: "server", ofType: "cer")!
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                }
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:IdentityAndTrust = self.extractIdentity();
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }
                // 其它情况（不接受认证）
            else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        
        Alamofire.request("https://passport.shangpin.com/mapi/systime", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { response in
            print(response)
        }
    }
    //获取客户端证书相关信息
    func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "server", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "0"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
                print("\(identityPointer)  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                print("\(trustPointer)  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
    
    //定义一个结构体，存储认证相关信息
    struct IdentityAndTrust {
        var identityRef:SecIdentity
        var trust:SecTrust
        var certArray:AnyObject
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
