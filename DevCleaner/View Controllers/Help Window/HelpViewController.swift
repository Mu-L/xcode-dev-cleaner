//
//  HelpViewController.swift
//  DevCleaner
//
//  Created by Konrad Kołakowski on 07/09/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//
//  DevCleaner is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 3 of the License, or
//  (at your option) any later version.
//
//  DevCleaner is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with DevCleaner.  If not, see <http://www.gnu.org/licenses/>.

import Cocoa
@preconcurrency import WebKit

final class HelpViewController: NSViewController {
    // MARK: Properties & outlets
    @IBOutlet private weak var helpWebView: WKWebView!
    
    // MARK: Initialization & overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // [1] workaround to prevent "blinking" of help background when in dark mode:
        //     https://stackoverflow.com/a/67674061
        
        // configuration
        self.helpWebView.setValue(true as NSNumber, forKey: "drawsTransparentBackground") // [1]
        self.helpWebView.navigationDelegate = self
        
        // load manual HTML
        guard let helpUrl = Bundle.main.url(forResource: "manual", withExtension: "html", subdirectory: "Manual") else {
            log.error("HelpViewController: Can't find manual HTML file!")
            return
        }
        
        self.helpWebView.loadFileURL(helpUrl, allowingReadAccessTo: helpUrl.deletingLastPathComponent())
    }
}

extension HelpViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        
        decisionHandler(.allow)
    }
}
