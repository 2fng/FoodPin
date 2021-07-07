//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Hua Son Tung on 06/07/2021.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    lazy var dataSource = configureDataSource()
    
    enum Section {
        case feedback
        case followUs
    }
    
    struct LinkItem: Hashable {
        var text: String
        var link: String
        var image: String
    }
    
    var sectionContent = [
        [ LinkItem(text: "Rate us on App Store", link: "https://www.apple.com/ios/app-store/", image: "store"),
          LinkItem(text: "Tell us your feedback", link: "http://www.appcoda.com/contact", image: "chat") ],
        
        [ LinkItem(text: "Twitter", link: "https://twitter.com/appcodamobile", image: "twitter"),
          LinkItem(text: "Facebook", link: "https://facebook.com/appcodamobile", image: "facebook"),
          LinkItem(text: "Instagram", link: "https://www.instagram.com/appcodadotcom", image: "instagram")]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lartge title for the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Customize the navigation bar appearance
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            appearance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0){
                
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        //Load table data
        tableView.dataSource = dataSource
        updateSnapshot()
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, LinkItem> {
        
        let cellIdentifier = "aboutcell"
        
        let dataSource = UITableViewDiffableDataSource<Section, LinkItem>(tableView: tableView) {
            (tableView, indexPath, linkItem) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = linkItem.text
            cell.imageView?.image = UIImage(named: linkItem.image)
            
            return cell
        }
        
        return dataSource
    }
    
    func updateSnapshot() {
        
        //Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, LinkItem>()
        
        snapshot.appendSections([.feedback, .followUs])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .followUs)
        
        dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
        
            case 0: performSegue(withIdentifier: "showWebView", sender: self)
            
            case 1: openWithSafariViewController(indexPath: indexPath)
                
        default: break
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        //Get the selected link item
//        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
//            return
//        }
//
//        if let url = URL(string: linkItem.link) {
//            UIApplication.shared.open(url)
//        }
//
//        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWebView" {
            if let destinationController = segue.destination as? WebViewController,
               
               let indexPath = tableView.indexPathForSelectedRow,
               let linkItem = self.dataSource.itemIdentifier(for: indexPath) {
                
                destinationController.targetURL = linkItem.link
            }
        }
    }
    
    func openWithSafariViewController(indexPath: IndexPath) {
        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        if let url = URL(string: linkItem.link) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }

}