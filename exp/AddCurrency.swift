import UIKit
import CoreData

class AddCurrency: UIViewController {
    @IBOutlet weak var mytable: UITableView!
    @IBOutlet weak var mysearch: UISearchBar!
    @IBOutlet weak var mylabel: UILabel!
    
    let identifier = "myCell"
    var i = 0
    
    var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let context = CoreDataManager.instance.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let section = "name"
        fetchRequest.sortDescriptors = [sortDescriptor]
        let statusPredicate = NSPredicate(format: "status == %@", NSNumber(value: false))
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate])
        fetchRequest.predicate = datePredicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: section, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mytable.backgroundColor = UIColor.clear
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    static func storyboardInstance() -> AddCurrency? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddCurrency") as? AddCurrency
    }
    

    @IBAction func back(_ sender: UIButton) {
        let testVC = Currencies.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(testVC!, animated: false, completion: nil)
    }
    
}

extension AddCurrency: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath) as! Currency
        //print(customer)
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "myCell")
        if (cell == nil)
        {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "myCell")
            print("cell nil")
        }
        /*
         if indexPath.section == 0 {
         cell?.textLabel?.text = "New category / note"
         cell?.imageView?.image = UIImage(named: "Group")
         } else {
         cell?.textLabel?.text = customer.name
         cell?.imageView?.image = UIImage(named: customer.image?.name ?? "")
         }
         */
        
        cell?.textLabel?.text = customer.name
        cell?.detailTextLabel?.text = customer.code
        //cell?.imageView?.image = UIImage(named: customer.image?.name ?? "")
        
        cell?.detailTextLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.font = UIFont(name: "GothamPro-Medium", size: 18)
        cell?.textLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.text = ""
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let s: Int = self.fetchedResultsController.fetchedObjects?.count ?? 0
        return s
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 18))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 18.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 4
        cell.backgroundColor = .clear
        
        let layer = CAShapeLayer()
        let pathRef = CGMutablePath()
        let bounds = cell.bounds.insetBy(dx: 0, dy: 0)
        var addLine = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.minY), tangent2End: .init(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.minY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: .init(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: .init(x: bounds.minX, y: bounds.maxY), tangent2End: .init(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
            pathRef.addArc(tangent1End: .init(x: bounds.maxX, y: bounds.maxY), tangent2End: .init(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
            pathRef.addLine(to: .init(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.addRect(bounds)
            addLine = true
        }
        
        layer.path = pathRef
        layer.fillColor = UIColor(white: 1, alpha: 0.1).cgColor
        
        if (addLine == true) {
            let lineLayer = CALayer()
            let lineHeight = 1.0 / UIScreen.main.scale
            lineLayer.frame = CGRect(x: bounds.minX + 10, y: bounds.size.height - lineHeight, width: bounds.size.width - 10, height: lineHeight)
            lineLayer.backgroundColor = tableView.separatorColor?.cgColor
            layer.addSublayer(lineLayer)
        }
        
        let testView = UIView(frame: bounds)
        testView.layer.insertSublayer(layer, at: 0)
        testView.backgroundColor = .clear
        cell.backgroundView = testView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = fetchedResultsController.object(at: indexPath) as! Currency
        
        customer.status = true
        CoreDataManager.instance.saveContext()
        
        let testVC = Currencies.storyboardInstance()
        testVC?.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        
        self.present(testVC!, animated: false, completion: nil)
    }
 
    /*    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     i = 0
     guard !searchText.isEmpty else {
     currentarray = array
     myTableView.reloadData()
     return
     }
     currentarray = array.filter({ (elem) -> Bool in
     elem.name.lowercased().contains(searchText.lowercased())
     })
     myTableView.reloadData()
     }*/
}


