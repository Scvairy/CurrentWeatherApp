//
//  Created by Timur Sharifyanov on 18/12/2019.
//  Copyright © 2019 Timur Sharifyanov. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController {

    var tableView: UITableView!

    var appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedRC: NSFetchedResultsController<Record>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func setup() {
        tableView = UITableView()
        view = tableView

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(RecordCellView.self, forCellReuseIdentifier: RecordCellView.identifier)

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }

    func refresh() {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Record.date, ascending: false)
        ]
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedRC.performFetch()
            print("History refreshed")
        } catch let error as NSError {
            print("Error on fetch records. \(error), \(error.userInfo)")
        }
    }
}

extension HistoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedRC.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordCellView.identifier, for: indexPath) as! RecordCellView
        let record = fetchedRC.object(at: indexPath)
        cell.titleText = record.city?.name ?? "No city name".localized()
        cell.date = record.date!
        cell.imageName = record.condition?.icon
        return cell
    }

}

extension HistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let record = fetchedRC.object(at: indexPath)
        let vc = RecordViewController()
        vc.record = record
        vc.updateViews()
        vc.isRefreshable = false
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        guard let date = record.date else { return }
        vc.title = formatter.string(from: date)
        navigationController?.pushViewController(vc, animated: true)
    }
}
