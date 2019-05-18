import UIKit
import CoreData

class Currencies: UIViewController {
    @IBOutlet weak var tyg: UITableView!

    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
    let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    fetchRequest.sortDescriptors = [sortDescriptor]
    let statusPredicate = NSPredicate(format: "status == %@", NSNumber(value: true))
    let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate])
    fetchRequest.predicate = datePredicate
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    fetchedResultsController.delegate = self
    return fetchedResultsController
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        regcell()
        tyg.separatorColor = UIColor(white: 1, alpha: 0.24)
        tyg.tableFooterView = UIView(frame: .zero)
        label()
    }
    
    func label() {
        let label = UILabel(frame: CGRect(x: 84, y: 380, width: 209, height: 36))
        label.font = UIFont(name: "GothamPro", size: 12)
        label.textColor = UIColor(white: 1, alpha: 0.45)
        label.text = "You can add up to three currencies\n\nSwipe to delete"
        label.numberOfLines = 3
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    static func storyboardInstance() -> Currencies? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "Currencies") as? Currencies
    }
    
    func regcell() {
        tyg.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "CurrencyTableViewCell")
        tyg.register(AddCurrencyTableViewCell.self, forCellReuseIdentifier: "AddCurrencyTableViewCell")
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        let testVC = Settings.storyboardInstance()
        self.present(testVC!, animated: false, completion: nil)
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension Currencies: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        //ошибка с CoreData
/*        if sections[section].numberOfObjects == 3 {
            return sections[section].numberOfObjects
        } else  {
            return sections[section].numberOfObjects + 1
        }
 */     return sections[section].numberOfObjects + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
/*        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        configureCell(cell, at: indexPath)
        return cell
*/
        func add() -> UITableViewCell{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCurrencyTableViewCell", for: indexPath) as! AddCurrencyTableViewCell
            tyg.rowHeight = 56
            
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            tyg.layer.backgroundColor = UIColor.clear.cgColor
            tyg.backgroundColor = .clear
            return cell
        }
        
        func cur() -> UITableViewCell{
            let currency = fetchedResultsController.object(at: indexPath) as! Currency
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
            tyg.rowHeight = 56
            
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            tyg.layer.backgroundColor = UIColor.clear.cgColor
            tyg.backgroundColor = .clear
            cell.nameLabel.text = currency.name
            cell.currency.text = currency.code
            return cell
        }
        
        if indexPath.row == fetchedResultsController.fetchedObjects!.count {
            return add()
        } else {
            return cur()
        }
    }
    
    func configureCell(_ cell: CurrencyTableViewCell, at indexPath: IndexPath) {
        let currency = fetchedResultsController.object(at: indexPath) as! Currency
        tyg.rowHeight = 56
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        tyg.layer.backgroundColor = UIColor.clear.cgColor
        tyg.backgroundColor = .clear
        cell.nameLabel.text = currency.name
        cell.currency.text = currency.code
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        func selectCurrency() {
            let currency = fetchedResultsController.object(at: indexPath) as! Currency
            let testVC = SelectCurrency.storyboardInstance()
            testVC?.selectCurrencyFromCurrencies = currency
            self.present(testVC!, animated: false, completion: nil)
        }
        
        func addCurrency() {
            let testVC = AddCurrency.storyboardInstance()
            self.present(testVC!, animated: false, completion: nil)
        }
        let s: Int = self.fetchedResultsController.fetchedObjects?.count ?? 0
        if s == 1 || s == 2 {
            if indexPath.row != s {
                selectCurrency()
            } else {
                addCurrency()
            }
        } else {
            selectCurrency()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let currency = fetchedResultsController.object(at: indexPath)
        
        if editingStyle == .delete {
            if self.fetchedResultsController.fetchedObjects?.count == 1 {
                let alert = UIAlertController(title: "Cannot remove last currency", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                CoreDataManager.instance.update(currency: currency as! Currency)
            }
         }
    }
}

//MARK: NSFetchedResultsControllerDelegate
extension Currencies: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tyg.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tyg.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tyg.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath, let cell = tyg.cellForRow(at: indexPath) {
                configureCell(cell as! CurrencyTableViewCell, at: indexPath)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tyg.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let newIndexPath = newIndexPath {
                tyg.insertRows(at: [newIndexPath], with: .fade)
            }
            break;
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tyg.endUpdates()
    }
}
