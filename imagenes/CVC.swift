//
//  CVC.swift
//  imagenes
//
//  Created by Rodrigo on 21/02/17.
//  Copyright © 2017 Rodrigo Hernandez. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct Seccion {
    var nombre: String
    var imagenes: [UIImage]
    
    init(nombre: String, imagenes: [UIImage]){
        self.nombre = nombre
        self.imagenes = imagenes
    }
}

class CVC: UICollectionViewController {
    
    var imagenes = [Seccion]()
    
    
    
    func busquedaGoogle(termino:String)->[UIImage]{
        var imgs = [UIImage]()
        let urls = "https://www.googleapis.com/customsearch/v1?key=AIzaSyB4aMJ05txRvvjWHiVE3l3m3gRkPaFC0Ds&cx=009549999974446203566:cg1bu8m0dgm&q=" + termino
        let url = NSURL(string:urls)
        do{
            let datos = try NSData(contentsOf: url! as URL)
            if datos != nil {
                print(datos!)
                let json = try JSONSerialization.jsonObject(with: datos! as Data, options: .mutableLeaves) as! NSDictionary
                let items =  (json["items"] as! NSArray)
                for elemento in items{
                    if (elemento as! NSDictionary)["pagemap"] != nil {
                        let pagemap = (elemento as! NSDictionary)["pagemap"] as! NSDictionary
                        if pagemap["cse_thumbnail"] != nil {
                            let cse_thumbnail = (pagemap["cse_thumbnail"] as! NSArray)[0] as! NSDictionary
                            let src = cse_thumbnail["src"] as! String
                            let img_url:NSURL = NSURL(string:src)!
                            let img_datos = try NSData(contentsOf:img_url as URL,options: NSData.ReadingOptions())
                            if let imagen = UIImage(data: img_datos as Data) {
                                imgs.append(imagen)
                            }
                        }
                    }
                }
            }
            
        }
        catch _ {

        }
        print("Total imagenes descargadas: \(imgs.count)")
        return imgs
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        /* IMPORTANT: Se comenta esta linea autogenerada,
         ya que hay conflicto si se diseña usando storyboard entonces se comentará esta siguiente línea:
         -->
         self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        */
        // Do any additional setup after loading the view.
    }

    @IBAction func buscar(_ sender: UITextField) {
        let seccion = Seccion(nombre: sender.text!, imagenes: busquedaGoogle(termino: sender.text!))
        imagenes.append(seccion)
        self.collectionView!.reloadData()
        print(busquedaGoogle(termino: sender.text!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return imagenes.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        // Retornar el numero de items en la seccion indicada
        //  ( imagenes = Array [struct Seccion] ) . ( elemento de struct = imagenes = Array UIImage) . count
        return imagenes[section].imagenes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImgCelda
        cell.imagen.image = imagenes[indexPath.section].imagenes[indexPath.item]
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
