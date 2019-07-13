//
//  LightControllerViewController.swift
//  yeelight
//
//  Created by Gabriel Tomaz on 13/07/19.
//  Copyright © 2019 Gabriel Tomaz. All rights reserved.
//

import UIKit
import ChromaColorPicker

class LightControllerViewController: UIViewController {
    
    let device: Device
    let neatColorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
    @IBOutlet weak var colorPickerContainer: UIView!
    @IBOutlet weak var colorTempSlider: UISlider!
    @IBOutlet weak var toggleLight: UISwitch!
    
    init(device: Device) {
        self.device = device
        super.init(nibName: "LightControllerViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.connectDevice() {
            self.setupUI()
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func connectDevice() -> Bool {
        return self.device.connect()
    }
    
    private func setupUI() {
        
        self.neatColorPicker.delegate = self //ChromaColorPickerDelegate
        self.neatColorPicker.padding = 5
        self.neatColorPicker.stroke = 3
        self.neatColorPicker.hexLabel.textColor = UIColor.white
        self.colorPickerContainer.addSubview(self.neatColorPicker)
        self.toggleLight.isOn = self.device.isOn
    }
    
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        self.device.swichtLight(sender.isOn)
    }
    
    @IBAction func switchChanged(_ sender: UISlider) {
        self.device.changeCT(Int(sender.value))
    }
}

extension LightControllerViewController: ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var hue : CGFloat = 0
        var fAlpha: CGFloat = 0
        
        if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &fAlpha) {
            
            let result = hue * 359
            
            self.device.changeColor(Int(result))
        }
    }
}

extension UIColor {
    
    func rgb() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
}
