//
//  ExtensionOfTableView.swift
//  Collaboration
//
//  Created by Data on 18.05.24.
//

import UIKit

extension SpecieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        observations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpecieTableViewCell", for: indexPath) as! SpecieTableViewCell
        let observation = observations[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(specieName: observation.taxon.name ?? "Unknown",
                       nameUploader: observation.taxon.default_photo?.attribution ?? "",
                               image: observation.taxon.default_photo?.square_url ?? "",
                               wikipediaURL: observation.taxon.wikipedia_url)
        return cell
    }
}


extension SpecieViewController: UITableViewDelegate {
    
}
