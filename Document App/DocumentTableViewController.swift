//
//  DocumentTableViewController.swift
//  Document App
//
//  Created by Dylan BATTIG on 11/18/24.
//

import UIKit
import QuickLook

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
            DocumentFile(title: "image-1.jpg", size: 1655939, imageName: Optional("image-1.jpg"), url: URL(fileURLWithPath: "file:///Users/battigd/Library/Developer/CoreSimulator/Devices/26B84220-28F8-48D8-974A-B1E80113299C/data/Containers/Bundle/Application/007B5D5A-DB55-435D-A0B7-37341CBE7AAB/Document%20App.app/image-1.jpg"), type: "public.jpeg"),
            
            DocumentFile(title: "image-2.jpg", size: 2554657, imageName: Optional("image-2.jpg"), url: URL(fileURLWithPath: "file:///Users/battigd/Library/Developer/CoreSimulator/Devices/26B84220-28F8-48D8-974A-B1E80113299C/data/Containers/Bundle/Application/3D2CB84A-9A59-4ADE-8AC8-0D6A43ADD54F/Document%20App.app/image-2.jpg"), type: "public.jpeg"),
            
            DocumentFile(title: "image-3.jpg", size: 773954, imageName: Optional("image-3.jpg"), url: URL(fileURLWithPath: "file:///Users/battigd/Library/Developer/CoreSimulator/Devices/26B84220-28F8-48D8-974A-B1E80113299C/data/Containers/Bundle/Application/007B5D5A-DB55-435D-A0B7-37341CBE7AAB/Document%20App.app/image-3.jpg"), type: "public.jpeg"),
        ]
        
        var title: String
        var size: Int
        
        var imageName: String?
        
        var url: URL
        var type: String
    }
    
    var documents: [DocumentFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.documents = self.listFileInBundle()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        let document = documents[indexPath.row]
        
        cell.textLabel?.text = document.title
        cell.detailTextLabel?.text = document.size.formattedSize()
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = documents[indexPath.row]
        self.instantiateQLPreviewController(withUrl: file.url)
    }
    
    func instantiateQLPreviewController(withUrl url: URL) {
        let previewController = QLPreviewController()
        
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = documents.firstIndex{ $0.url == url }!
        
        self.present(previewController, animated: true)
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

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return documents.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let document = documents[index]
        return document.url as QLPreviewItem
    }
}
