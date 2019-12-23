//
//  Created by Timur Sharifyanov on 18/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class RecordViewController: UIViewController {

    //MARK:- Internal variables
    weak var root: RootTabBarController?
    var record: Record?
    var isRefreshable: Bool?
    var textColor: UIColor = .darkText {
        didSet {
            cityLabel.textColor = textColor
            conditionLabel.textColor = textColor
            tempLabel.textColor = textColor
            wrapperView.refreshControl?.tintColor = textColor
            imageView.tintColor = textColor
        }
    }

    //MARK:- Private variables
    private var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var darkAppearance: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       wrapperView.refreshControl = UIRefreshControl()
       wrapperView.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
       // Update your content…
        root?.reloadData()

       // Dismiss the refresh control.
//        onMainThread {
//          self.wrapperView.refreshControl?.endRefreshing()
//       }
    }

//    private var isIndicatorShown: Bool = true {
//        didSet {
//            isIndicatorShown ? indicatorView.startAnimating() : indicatorView.stopAnimating()
//            indicatorView.isHidden = !isIndicatorShown
//        }
//    }

    //MARK:- Private view variables
    private var spinnerView: UIView?
//    private var indicatorView: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .whiteLarge)
//        indicator.startAnimating()
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
    private var wrapperView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var stackView = UIStackView()

    private var imageWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var cityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var conditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK:- Internal Functions
    init(isRefreshable: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isRefreshable = isRefreshable
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    //MARK:- Internal Functions
    func updateData(with json: JSON) {
        NSLog("Update by JSON from \(#function)")
        record = Record.addRecord(from: json, insertInto: context)
        guard record != nil else { return }
        updateViews(fromCache: false)
        appDelegate.saveContext()
    }

    //MARK:- Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layoutViews()
    }
    var isInitialAppearing: Bool = true
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews(fromCache: isInitialAppearing)
        isInitialAppearing = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkAppearance ? .lightContent : .default
    }

    //MARK:- Private functions
    private func setup() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        if record == nil {
            let request: NSFetchRequest<Record> = Record.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Record.date, ascending: false)]
            request.fetchLimit = 1
            do {
                record = try context.fetch(request).first
                print("Last record fetched")
                updateViews(fromCache: true)
            } catch let error as NSError {
                print("Error on fetch last record. \(error), \(error.userInfo)")
            }
        }

        view.addSubview(wrapperView)
        wrapperView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight,
        ]
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center

        imageWrapper.addSubview(imageView)
        let separator1 = UIView()
        separator1.autoresizingMask = [.flexibleHeight]
        let separator2 = UIView()
        separator2.autoresizingMask = [.flexibleHeight]
        if let isRefreshable = isRefreshable, isRefreshable {
            configureRefreshControl()
        }
        _ = [separator1, cityLabel, conditionLabel, imageWrapper, tempLabel, separator2].compactMap {
            stackView.addArrangedSubview($0)
        }
    }

    private func layoutViews() {
        if #available(iOS 11.0, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                wrapperView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                wrapperView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),

                wrapperView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1),
                guide.bottomAnchor.constraint(equalToSystemSpacingBelow: wrapperView.bottomAnchor, multiplier: 1),

//                guide.trailingAnchor.constraint(greaterThanOrEqualTo: imageWrapper.trailingAnchor, constant: 8)
            ])
        } else {
            // TODO: Check on iOS 10
            NSLayoutConstraint.activate([
                wrapperView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                wrapperView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                wrapperView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
                wrapperView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            ])
        }

        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: wrapperView.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),

            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 256),
            imageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            imageWrapper.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            imageWrapper.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageWrapper.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }

    func updateViews(fromCache: Bool = true) {
        onMainThread {
            NSLog("\(#function)")
//            if record == nil, spinnerView == nil {
//                wrapperView.refreshControl?.beginRefreshing()
//            } else if record != nil {
//                wrapperView.refreshControl?.endRefreshing()
//            }
            cityLabel.text = record?.city?.name ?? "City".localized()
            conditionLabel.text = record?.condition?.desc ?? "weather condition".localized()
            tempLabel.text = record != nil ? "\(record!.data!.temp) C°" : ""
            let now = record?.date ?? Date()
            let sunrise = record?.sunrise ?? Date(timeIntervalSince1970: 0)
            let sunset = record?.sunset ?? Date(timeIntervalSince1970: 0)
            let dayTime = WeatherColors.TimeOfDay(date: now, sunrise: sunrise, sunset: sunset)
            darkAppearance = WeatherColors.isItDark(for: dayTime)
            let tintColor = WeatherColors.label(for: dayTime)

            imageView.image = UIImage(named: record?.condition?.icon ?? "umbrella.splash")?.withRenderingMode(.alwaysTemplate)
            textColor = tintColor
            view.backgroundColor = WeatherColors.background(for: dayTime)
            if fromCache {
                wrapperView.refreshControl?.beginRefreshing()
            } else {
                wrapperView.refreshControl?.endRefreshing()
            }
        }
    }
}
