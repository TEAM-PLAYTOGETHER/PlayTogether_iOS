//
//  ShareViewController.swift
//  CodeShareExtension
//
//  Created by 이지석 on 2022/09/27.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return self.contentText.isEmpty ? false : true
    }

    override func didSelectPost() {
        // MARK: 보내기 버튼 클릭 시
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func didSelectCancel() {
        // MARK: 취소 버튼 클릭 시
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
