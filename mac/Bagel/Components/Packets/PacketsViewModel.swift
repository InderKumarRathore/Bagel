//
//  PacketViewModel.swift
//  Bagel
//
//  Created by Yagiz Gurgul on 1.10.2018.
//  Copyright © 2018 Yagiz Lab. All rights reserved.
//

import Cocoa

class PacketsViewModel: BaseListViewModel<BagelPacket>  {
    
    var addressFilterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    var methodFilterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    var statusFilterTerm = "" {
        didSet {
            self.refreshItems()
        }
    }
    
    private var allPackets: [BagelPacket] {
        return BagelController.shared.selectedProjectController?.selectedDeviceController?.packets ?? []
    }
    
    
    func register() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didGetPacket, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didUpdatePacket, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didSelectProject, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshItems), name: BagelNotifications.didSelectDevice, object: nil)
    }
    
    var selectedItem: BagelPacket? {
        return BagelController.shared.selectedProjectController?.selectedDeviceController?.selectedPacket
    }
    
    var selectedItemIndex: Int? {
        guard let selectedItem = self.selectedItem else { return nil }
        
        return self.items.firstIndex { $0 === selectedItem }
    }
    
    @objc func refreshItems() {
        items = filter(items: allPackets)
        onChange?()
    }
    
    func filter(items: [BagelPacket]) -> [BagelPacket] {
        var filteredItems = performAddressFiltration(items)
        filteredItems = performMethodFiltration(filteredItems)
        filteredItems = performStatusFiltration(filteredItems)
        return performUrlFiltration(filteredItems)
    }
    
    func performAddressFiltration(_ items: [BagelPacket])  -> [BagelPacket] {
        guard addressFilterTerm.count > 0 else {
            return items
        }
        
        return items.filter {
            $0.requestInfo?.url?.contains(self.addressFilterTerm) ?? true }
    }
    
    func performMethodFiltration(_ items: [BagelPacket])  -> [BagelPacket] {
        guard methodFilterTerm.count > 0 else {
            return items
        }
        
        return items.filter
            { $0.requestInfo?.requestMethod?.rawValue.lowercased()
                .contains(self.methodFilterTerm.lowercased()) ?? true }
    }
    
    func performStatusFiltration(_ items: [BagelPacket])  -> [BagelPacket] {
        guard statusFilterTerm.count > 0 else {
            return items
        }
        
        guard !statusFilterTerm.trimmingCharacters(in: .whitespaces).isEmpty else {
            return items.filter { $0.requestInfo?.statusCode?.trimmingCharacters(in: .whitespaces).isEmpty ?? true}
        }
        
        return items.filter
            { $0.requestInfo?.statusCode?.contains(self.statusFilterTerm) ?? false
        }
    }

    private let ignoreUrlPermanentList: Set<String> = [

    ]
    func performUrlFiltration(_ items: [BagelPacket]) -> [BagelPacket] {
        items.filter { bagelPacket in
            !ignoreUrlPermanentList.contains { url in
                bagelPacket.requestInfo?.url?.hasPrefix(url) == true
            }
        }
    }
    
    func clearPackets() {
        BagelController.shared.selectedProjectController?.selectedDeviceController?.clear()
        self.refreshItems()
    }
}
