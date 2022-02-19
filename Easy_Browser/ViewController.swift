//
//  ViewController.swift
//  Easy_Browser
//
//  Created by Mohamed Kamal on 05/02/2022.
//

import UIKit
import WebKit
class ViewController: UIViewController,WKNavigationDelegate {

    var webview : WKWebView!
    var progress : UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    override func loadView() {
        webview = WKWebView()
        webview.navigationDelegate = self
        view = webview
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let url = URL(string: "https://"+websites[0])!
        webview.load(URLRequest(url: url))
        webview.allowsBackForwardNavigationGestures = true
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webview, action: #selector(webview.reload))
        
        progress = UIProgressView(progressViewStyle: .default)
        progress.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progress)
        
        toolbarItems=[progressButton,space,refresh]
        navigationController?.isToolbarHidden = false
        
        webview.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
    }
    @objc func openTapped()
    {
        let ac = UIAlertController(title: "Open Page ...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac , animated: true)
    }
    func openPage(action : UIAlertAction)
    {
        let url = URL(string: "https://"+action.title!)!
        webview.load(URLRequest(url : url))
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webview.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
        if keyPath == "estimatedProgress"
        {
            progress.progress = Float(webview.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
    }


}

