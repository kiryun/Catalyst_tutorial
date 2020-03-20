//
/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
    

import Foundation

import UIKit

#if targetEnvironment(macCatalyst)
extension MarkupViewController: NSToolbarDelegate {
  //1
  enum Toolbar {
    static let colors = NSToolbarItem.Identifier(rawValue: "colors")
    static let share = NSToolbarItem.Identifier(rawValue: "share")
    static let addImage = NSToolbarItem.Identifier(rawValue: "addImage")
  }
  
  //2
  func toolbar(_ toolbar: NSToolbar,
               itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
               willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
    //3
    if itemIdentifier == Toolbar.colors {
      let items = AppColors.colorSpace
        .enumerated()
        .map { (index,slice) -> NSToolbarItem in
          let item = NSToolbarItem()
          item.image = UIImage.swatch(slice.1)
          item.target = self
          item.action = #selector(colorSelectionChanged(_:))
          item.tag = index
          item.label = slice.0
          return item
        }
      
      let group = NSToolbarItemGroup(itemIdentifier: Toolbar.colors)
      group.subitems = items
      group.selectionMode = .momentary
      group.label = "Text Background"
      
      return group
    }
    //4
    else if itemIdentifier == Toolbar.addImage {
      let item = NSToolbarItem(itemIdentifier: Toolbar.addImage)
      item.image = UIImage(systemName: "photo")?.forNSToolbar()
      item.target = self
      item.action = #selector(chooseImageAction)
      item.label = "Add Image"
      
      return item
    }
    else if itemIdentifier == Toolbar.share {
      let item = NSToolbarItem(itemIdentifier: Toolbar.share)
      item.image = UIImage(systemName: "square.and.arrow.up")?.forNSToolbar()
      item.target = self
      item.action = #selector(shareAction)
      item.label = "Share Item"
      
      return item
    }
    
    return nil
  }
  
  //5
  func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar)
    -> [NSToolbarItem.Identifier] {
    return [Toolbar.colors,Toolbar.addImage,.flexibleSpace,Toolbar.share]
  }
  
  func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar)
    -> [NSToolbarItem.Identifier] {
    return self.toolbarDefaultItemIdentifiers(toolbar)
  }
  
  //6
  @objc func colorSelectionChanged(_ sender: NSToolbarItem) {
    guard let template = currentContent else {
      return
    }
    template.textBackgroundColor = AppColors.colors[sender.tag]
    currentContent = template
  }
}
#endif

extension MarkupViewController {
  func buildMacToolbar() {
    #if targetEnvironment(macCatalyst)
    guard let windowScene = view.window?.windowScene else {
      return
    }
    
    if let titlebar = windowScene.titlebar {
      let toolbar = NSToolbar(identifier: "toolbar")
      toolbar.delegate = self
      toolbar.allowsUserCustomization = true
      titlebar.toolbar = toolbar
    }
    #endif
  }
}
