//
//  RecordCellView.swift
//  CurrentWeather
//
//  Created by Timur Sharifyanov on 20/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit

class RecordCellView: UITableViewCell {

    static let identifier = "recordCell"

    public var titleText: String = "" {
        didSet {
            textLabel?.text = titleText
        }
    }

    public var date: Date = Date() {
        didSet {
            detailTextLabel?.text = formatter.string(from: date)
        }
    }

    public var imageName: String? {
        didSet {
            guard let name = imageName else { return }

            imageView?.image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
            if #available(iOS 13.0, *) {
                imageView?.tintColor = .label
            } else {
                imageView?.tintColor = .black
            }
        }
    }

    private let formatter = DateFormatter()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
//        formatter.dateFormat = "d MMM yyyy, HH:mm:ss"
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        accessoryType = .disclosureIndicator
    }
}
