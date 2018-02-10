//
//  EventTableDelegate.swift
//  Events
//
//  Created by A Boon-Eye on 1/26/18.
//  Copyright © 2018 Jeffrey Baucom. All rights reserved.
//

import UIKit

protocol EventTableDelegate: class {
    func savePressed(by controller: AddEventVC)
    func savePressedEdit(by controller: AddEventVC)
    func goToEdit(path: IndexPath)
}
