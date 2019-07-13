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
    
    func rgbToHue(r:CGFloat,g:CGFloat,b:CGFloat) -> (h:CGFloat, s:CGFloat, b:CGFloat) {
        
        let minV:CGFloat = CGFloat(min(r, g, b))
        let maxV:CGFloat = CGFloat(max(r, g, b))
        let delta:CGFloat = maxV - minV
        var hue:CGFloat = 0
        if delta != 0 {
            if r == maxV {
                hue = (g - b) / delta
            }
            else if g == maxV {
                hue = 2 + (b - r) / delta
            }
            else {
                hue = 4 + (r - g) / delta
            }
            hue *= 60
            if hue < 0 {
                hue += 360
            }
        }
        let saturation = maxV == 0 ? 0 : (delta / maxV)
        let brightness = maxV
        return (h:hue/360, s:saturation, b:brightness)
    }
}
