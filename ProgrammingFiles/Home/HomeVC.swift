//
//  HomeVC.swift
//  NetLet
//
//  Created by Mohammed Yusuf Mitha on 02/03/20.
//  Copyright © 2020 Mohammed Yusuf Mitha. All rights reserved.
//

import UIKit
import Stevia

class HomeVC: Base {

    var myTableView = UITableView()
    var reportIssueButton = UIButton()
    
    var reportedButton = UIButton()
    var approvedButton = UIButton()
    
    var currentButton : UIButton?
    
    var fetchedIssues : IssuesModel?
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchIssues()
    }
    func setUpView(){
        self.view.backgroundColor = myBackgroundColor

        self.view.addSubview(myTableView)
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(reportedButton)
        reportedButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(approvedButton)
        approvedButton.translatesAutoresizingMaskIntoConstraints = false
        
        myTableView.fillHorizontally()
        myTableView.topAnchor.constraint(equalTo: approvedButton.bottomAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        myTableView.register(HomeCV.self, forCellReuseIdentifier: "HomeCV")
        myTableView.showsVerticalScrollIndicator = false
        myTableView.showsHorizontalScrollIndicator = false
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 10
        topBar.title.text = "Issues"
        
        topBar.addSubview(reportIssueButton)
        reportIssueButton.translatesAutoresizingMaskIntoConstraints = false

        reportIssueButton.topAnchor.constraint(equalTo: topBar.topAnchor).isActive = true
        reportIssueButton.trailingAnchor.constraint(equalTo: topBar.trailingAnchor,constant: -10*iPhoneFactorX).isActive = true
        reportIssueButton.bottomAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        reportIssueButton.adjustDefaultButton(fontColor: "#ffffff", fontSize: 15, fontType: "2")
        reportIssueButton.setTitle("Report Issue", for: .normal)
        reportIssueButton.addTarget(self, action: #selector(reportIssueButtonAction), for: .touchUpInside)
        
        reportedButton.adjustDefaultButton(fontColor: "#000000", fontSize: 15, fontType: "2")
        reportedButton.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        reportedButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        reportedButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reportedButton.heightAnchor.constraint(equalToConstant: 50*iPhoneFactorX).isActive = true
        reportedButton.addTarget(self, action: #selector(reportedButtonAction), for: .touchUpInside)
        reportedButton.setTitle("Reported", for: .normal)
        
        approvedButton.adjustDefaultButton(fontColor: "#000000", fontSize: 15, fontType: "2")
        approvedButton.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        approvedButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        approvedButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        approvedButton.heightAnchor.constraint(equalToConstant: 50*iPhoneFactorX).isActive = true
        approvedButton.addTarget(self, action: #selector(approvedButtonAction), for: .touchUpInside)
        approvedButton.setTitle("Resolved", for: .normal)
        
        
        reportedButton.sendActions(for: .touchUpInside)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        myTableView.addSubview(refreshControl) 
    }
    @objc func refresh() {
       fetchIssues()
    }
    func fetchIssues(){
        API.callDictionaryAPI(webserviceFor: StringIdentifiers.getIssues, webMethod: .get, parameters: [:]) { (error, task) in
            self.fetchedIssues = (task as? IssuesModel)
            self.myTableView.reloadData()
            self.refreshControl.endRefreshing()
             
        }
    }
    
    @objc func reportedButtonAction(){
        selectButton(reportedButton)
        deselectButton(approvedButton)
    }
    @objc func approvedButtonAction(){
        selectButton(approvedButton)
        deselectButton(reportedButton)
    }
    
    func selectButton(_ sender : UIButton){
        sender.addBottomLine(withColor: myOrangeColor)
        currentButton = sender
        self.myTableView.reloadData()
    }
    func deselectButton( _ sender : UIButton){
        sender.addBottomLine(withColor: myBackgroundColor)
        self.myTableView.reloadData()

    }
    
    @objc func reportIssueButtonAction(){
        let dest = ReportVC()
        self.navigationController?.pushViewController(dest, animated: true)
        
    }
    
}
extension HomeVC : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentButton == approvedButton){
            return fetchedIssues?.approved?.count ?? 0
        } else {
            return fetchedIssues?.pending?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCV", for: indexPath) as? HomeCV else {
            return UITableViewCell()
        }
        if (currentButton == approvedButton){
            cell.setUpView(fetchedIssues?.approved?[indexPath.row])
        } else {
            cell.setUpView(fetchedIssues?.pending?[indexPath.row])
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dest = ReportVC()
        dest.comingForDetails = true
        if (currentButton == approvedButton){
            dest.issueObject = fetchedIssues?.approved?[indexPath.row]
        } else {
           dest.issueObject = fetchedIssues?.pending?[indexPath.row]
        }
        
        self.navigationController?.pushViewController(dest, animated: true)
    }
}
