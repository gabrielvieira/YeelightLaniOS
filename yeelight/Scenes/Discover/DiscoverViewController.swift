//
//  DiscoverViewController.swift
//  yeelight
//
//  Created by Gabriel Tomaz on 13/07/19.
//  Copyright © 2019 Gabriel Tomaz. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var devices: [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        Socket.sharedInstance().searchDevice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.getDevices()
        })
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func refreshDidTap(_ sender: Any) {
        self.getDevices()
    }
    
    private func getDevices() {
        let deviceResult = Socket.sharedInstance().getDevices().values
        self.devices = deviceResult.compactMap{
            $0 as? Device
        }
        print(self.devices)
        self.tableView.reloadData()
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let device = self.devices[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(device.did)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let device = self.devices[indexPath.row]
        let controller = LightControllerViewController(device: device)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
