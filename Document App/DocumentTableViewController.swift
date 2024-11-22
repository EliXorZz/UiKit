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
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    var importedDocuments: [DocumentFile] = []
    var documents: [DocumentFile] = []
    
    var filteredImportedDocuments: [DocumentFile] = []
    var filteredDocuments: [DocumentFile] = []
    
    var current: [DocumentFile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
        self.searchBar.delegate = self
        
        self.loadFiles()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Importations"
        case 1:
            return "Bundles"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return filteredImportedDocuments.count
        case 1:
            return filteredDocuments.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)
        var document: DocumentFile?
        
        switch indexPath.section {
        case 0:
            document = self.filteredImportedDocuments[indexPath.row]
        case 1:
            document = self.filteredDocuments[indexPath.row]
        default:
            break
        }
        
        cell.textLabel?.text = document?.title
        cell.detailTextLabel?.text = document?.size.formattedSize()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.current = self.filteredImportedDocuments
        case 1:
            self.current = self.filteredDocuments
        default:
            break
        }
        
        let file = self.current[indexPath.row]
        self.instantiateQLPreviewController(withUrl: file.url)
    }
    
    @objc func addDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        
        present(documentPicker, animated: true)
    }
    
    func loadFiles() {
        self.importedDocuments = self.listFileInDocumentsDirectory()
        self.documents = self.listFileInBundle()
        
        self.filteredImportedDocuments = self.importedDocuments
        self.filteredDocuments = self.documents
    }
    
    func instantiateQLPreviewController(withUrl url: URL) {
        let previewController = QLPreviewController()
        
        previewController.dataSource = self
        previewController.currentPreviewItemIndex = self.current.firstIndex{ $0.url == url }!
        
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
    
    func listFileInDocumentsDirectory() -> [DocumentFile] {
        var documents = [DocumentFile]()
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let path = documentsDirectory.path
            let files = try FileManager.default.contentsOfDirectory(atPath: path)
            
            for file in files {
                let currentUrl = URL(fileURLWithPath: path + "/" + file)
                let resourcesValues = try! currentUrl.resourceValues(forKeys: [.contentTypeKey, .nameKey, .fileSizeKey])
                
                documents.append(DocumentFile(
                    title: resourcesValues.name!,
                    size: resourcesValues.fileSize ?? 0,
                    imageName: file,
                    url: currentUrl,
                    type: resourcesValues.contentType!.description
                ))
            }
        } catch {
            print(error)
        }
        
        return documents
    }
}

extension DocumentTableViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return current.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let document = self.current[index]
        return document.url as QLPreviewItem
    }
}

extension DocumentTableViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.dismiss(animated: true)

        guard url.startAccessingSecurityScopedResource() else {
            return
        }

        defer {
            url.stopAccessingSecurityScopedResource()
        }

        self.copyFileToDocumentsDirectory(fromUrl: url)
        
        self.loadFiles()
        self.tableView.reloadData()
    }

    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        // On récupère le dossier de l'application, dossier où nous avons le droit d'écrire nos fichiers
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Nous créons une URL de destination pour le fichier
        let destinationUrl = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            // Puis nous copions le fichier depuis l'URL source vers l'URL de destination
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print(error)
        }
    }
}

extension DocumentTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (!searchText.isEmpty) {
            self.filteredDocuments = self.documents.filter { (item: DocumentFile) -> Bool in
                return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            self.filteredImportedDocuments = self.importedDocuments.filter { (item: DocumentFile) -> Bool in
                return item.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
        }else {
            self.filteredDocuments = self.documents
            self.filteredImportedDocuments = self.importedDocuments
        }
        
        self.tableView.reloadData()
    }
}
