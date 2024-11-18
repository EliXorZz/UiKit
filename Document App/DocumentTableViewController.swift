//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Dylan BATTIG on 11/18/24.
//

import UIKit

extension Int {
    func formattedSize() -> String {
        let formater = ByteCountFormatter()
        formater.countStyle = .file
        
        return formater.string(fromByteCount: Int64(self))
    }
}

class DocumentTableViewController: UITableViewController {
    struct DocumentFile {
        static var documents = [
            DocumentFile(title: "image-1.jpg", size: 1655939, imageName: Optional("image-1.jpg"), url: URL(fileURLWithPath: "/Users/battigd/Library/Developer/CoreSimulator/Devices/26B84220-28F8-48D8-974A-B1E80113299C/data/Containers/Bundle/Application/DAF176F1-3292-4A99-B328-07AB338B9D94/Document%20App.app/image-1.jpg"), type: "public.jpeg"),
            
            DocumentFile(title: "image-2.jpg", size: 2554657, imageName: Optional("image-2.jpg"), url: URL(fileURLWithPath: "/Users/battigd/Library/Developer/CoreSimulator/Devices/26B84220-28F8-48D8-974A-B1E80113299C/data/Containers/Bundle/Application/DAF176F1-3292-4A99-B328-07AB338B9D94/Document%20App.app/image-2.jpg"), type: "public.jpeg"),
            
            DocumentFile(title: "image-3.jpg", size: 773954, imageName: Optional("image-3.jpg"), url: URL(fileURLWithPath: "/Users/battigd/Library/Developer/CoreSimulator/Devices/26B84220-28F8-48D8-974A-B1E80113299C/data/Containers/Bundle/Application/DAF176F1-3292-4A99-B328-07AB338B9D94/Document%20App.app/image-3.jpg"), type: "public.jpeg"),
        ]
        
        var title: String
        var size: Int
        
        var imageName: String?
        
        var url: URL
        var type: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocumentFile.documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document = DocumentFile.documents[indexPath.row]
        
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.size.formattedSize()
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController {
            let index = tableView.indexPathForSelectedRow!.row
            let document = DocumentFile.documents[index]
            
            destination.imageName = document.imageName
        }
    }
    
    func listFileInBundle() -> [DocumentFile] {  // Fonction retournant une liste de DocumentFile
        let fm = FileManager.default  // Instance FileManager
        let path = Bundle.main.resourcePath!  // Chemin du bundle
        let items = try! fm.contentsOfDirectory(atPath: path)  // Liste des fichiers du bundle
        
        var documentListBundle = [DocumentFile]()  // Liste vide pour stocker les fichiers
        
        for item in items {  // Parcourt les fichiers
            if !item.hasSuffix("DS_Store") && item.hasSuffix(".jpg") {  // Filtre les fichiers .jpg
                let currentUrl = URL(fileURLWithPath: path + "/" + item)  // Crée l'URL du fichier
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])  // Récupère infos sur le fichier
                
                documentListBundle.append(DocumentFile(  // Ajoute un DocumentFile à la liste
                    title: resourcesValues.name!,  // Nom du fichier
                    size: resourcesValues.fileSize ?? 0,  // Taille du fichier
                    imageName: item,  // Nom du fichier
                    url: currentUrl,  // URL du fichier
                    type: resourcesValues.contentType!.description  // Type MIME
                ))
            }
        }
        return documentListBundle  // Retourne la liste des fichiers
    }
}
