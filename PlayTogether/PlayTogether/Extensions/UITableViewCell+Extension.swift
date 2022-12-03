//
//  UITableView+Extension.swift
//  PlayTogether
//
//  Created by 한상진 on 2022/09/04.
//

import UIKit

extension UITableViewCell {
    func dateParser(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let convertDate = dateFormatter.date(from: dateString) else { return String.init() }
        
        dateFormatter.dateFormat = "yyyy.MM.dd.  HH:mm"
        return dateFormatter.string(from: convertDate)
    }
}
