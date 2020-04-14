
//
//  SLFriendDragListView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit

class SLFriendDragListView: UIView {
    var itemMargin: CGFloat = 0.0
    /**
     *  是否需要自定义ItemList高度，默认为Yes
     */
    var isFitItemListH = false
    /**
     *  是否需要排序功能
     */
    var isSort = false
    /**
     *  在排序的时候，放大标签的比例，必须大于1
     */
    var scaleItemInSort: CGFloat = 0.0
    //*****列表总列数 默认3列*****
    /**
     *  item间距会自动计算
     */
    var itemListCols = 0
    /**
     *  显示拖拽到底部出现删除 默认yes
     */
    var showDeleteView = false
    /**
     *  DragItemBottomView 的高度 默认50
     */
    var deleteViewHeight: CGFloat = 0.0
    /**
     *  item列表的高度
     */
    var itemListH: CGFloat {
        get {
            if items.count <= 0 {
                return 0
            }
            return items.last!.yxs_bottom + itemMargin
        }
    }
    /**
     *  item 最多个数 默认9个
     */
    var maxItem = 0
    
    /**
     *  添加item
     * */
    func addItem(_ item: SLFriendDragItem) {
        //移除“添加”item
        if items.count == maxItem {
            if item.isAdd == true {
                return
            }
            else{
                let last = items.last
                items.removeLast()
                last?.removeFromSuperview()
            }
        }
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickItem(_:)))
        item.addGestureRecognizer(tap)
        
        if isSort && !item.isAdd{
            let pan = UIPanGestureRecognizer.init(target: self, action: #selector(pan(_:)))
            item.addGestureRecognizer(pan)
        }
        addSubview(item)
        
        var tag = items.count
        var addItem: SLFriendDragItem! = nil
        if self.items.count > 0{
            let lastItem = self.items.last!
            if lastItem.isAdd{
                addItem = lastItem
                tag = lastItem.tag
                lastItem.tag = tag + 1
            }
        }
        item.tag = tag
        if addItem != nil{
            items.insert(item, at: self.items.count - 1)
        }else{
            items.append(item)
        }
        // 设置按钮的位置
        updateItemFrame(item.tag, extreMargin: true)
        if addItem != nil{
            updateItemFrame(addItem.tag, extreMargin: true)
        }
        // 更新自己的高度
        if isFitItemListH{
            var frame = self.frame
            frame.size.height = self.itemListH
            UIView.animate(withDuration: 0.25) {
                self.frame = frame
            }
        }
        
    }
    
    /**
     *  添加多个item
     */
    func addItems(_ items: [SLFriendDragItem]) {
        if self.width == 0{
            SLLog("先设置标签列表的frame")
            return
        }
        for item in items{
            addItem(item)
        }
    }
    /**
     *  点击标签，执行Block
     */
    var clickItemBlock: ((SLFriendDragItem) -> Void)?
    /**
     *  移除回调
     */
    var deleteItemBlock: ((SLFriendDragItem) -> Void)?
    
    // MARK: -privite
    private var items:[SLFriendDragItem] = [SLFriendDragItem]()
    private var itemSize = CGSize.zero
    /**
     *  需要移动的矩阵
     */
    private var moveFinalRect = CGRect.zero
    private var oriCenter = CGPoint.zero
    
    /**
     *  获取所有item
     */
    public func itemArray() ->[SLFriendDragItem] {
        return items
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 初始化
    func setup() {
        itemMargin = 10
        itemListCols = 3
        scaleItemInSort = 1
        isFitItemListH = true
        showDeleteView = true
        deleteViewHeight = 50.0
        maxItem = 9
        let width: CGFloat = (frame.size.width - (CGFloat((itemListCols + 1)) * itemMargin)) / CGFloat(itemListCols)
        itemSize = CGSize(width: width, height: width)
        clipsToBounds = true
    }
    
    // 点击标签
    
    @objc func clickItem(_ tap: UITapGestureRecognizer?) {
        
        dismissKeyBord()
        clickItemBlock?(tap?.view as! SLFriendDragItem)
    }
    
    @objc func pan(_ pan: UIPanGestureRecognizer?) {
        dismissKeyBord()
        let rect: CGRect = self.superview?.convert(self.frame, to: UIApplication.shared.keyWindow) ?? CGRect.zero
        // 获取偏移量
        let transP = pan!.translation(in: self)
        let tagButton:SLFriendDragItem = pan?.view as! SLFriendDragItem
        
        //开始
        if pan?.state == UIGestureRecognizer.State.began {
            oriCenter = tagButton.center
            UIView.animate(withDuration: 0.25) {
                tagButton.transform = CGAffineTransform.init(scaleX: self.scaleItemInSort, y: self.scaleItemInSort)
            }
            
            if self.showDeleteView{
                showDeleteViewAnimation()
            }
            
            UIApplication.shared.keyWindow?.addSubview(tagButton)
            
            tagButton.yxs_top = rect.minY + tagButton.yxs_top
            tagButton.yxs_left = rect.minX + tagButton.yxs_left
        }
        
        var center = tagButton.center
        center.x += transP.x
        center.y += transP.y
        tagButton.center = center
        
        //改变
        if pan?.state == UIGestureRecognizer.State.changed{
            // 获取当前按钮中心点在哪个按钮上
            let otherButton = buttonCenterInButtons(tagButton)
            if let otherButton = otherButton, !otherButton.isAdd{
                //获取插入的角标
                let i = otherButton.tag
                // 获取当前角标
                let curI = tagButton.tag
                moveFinalRect = otherButton.frame
                
                // 排序
                // 移除之前的按钮
                items.remove(at: items.firstIndex(of: tagButton) ?? 0)
                items.insert(tagButton, at: i)
                
                // 更新tag
                updateItem()
                if curI > i{// 往前插
                    
                    // 更新之后标签frame
                    UIView.animate(withDuration: 0.25) {
                        self.updateLaterItemButtonFrame(i + 1)
                    }
                }else{
                    // 往后插
                    
                    // 更新之前标签frame
                    UIView.animate(withDuration: 0.25) {
                        self.updateBeforeTagButtonFrame(i)
                    }
                }
            }
            if self.showDeleteView{
                if tagButton.frame.maxY > SCREEN_HEIGHT - deleteViewHeight{
                    setDeleteViewDeleteState()
                }else{
                    setDeleteViewNormalState()
                }
            }
        }
        
        //结束
        if pan?.state == UIGestureRecognizer.State.ended{
            var deleted = false
            if showDeleteView{
                hiddenDeleteViewAnimation()
                if tagButton.frame.maxY > SCREEN_HEIGHT - deleteViewHeight{
                    deleted = true
                    delete(tagButton)
                }
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                tagButton.transform = CGAffineTransform.identity
                if self.moveFinalRect.width <= 0{
                    tagButton.center = self.oriCenter
                }else{
                    tagButton.frame = self.moveFinalRect
                }
                tagButton.yxs_left += rect.minX
                tagButton.yxs_top += rect.minY
            }) { (finish) in
                if finish{
                    self.moveFinalRect = CGRect.zero
                    if !deleted{
                        self.addSubview(tagButton)
                        tagButton.yxs_left -= rect.minX
                        tagButton.yxs_top -= rect.minY
                    }
                }
            }
            
        }
        pan?.setTranslation(CGPoint.zero, in: self)
    }
    
    func buttonCenterInButtons(_ curItem: SLFriendDragItem) -> SLFriendDragItem?{
        for item in self.items{
            if curItem == item {
                continue
            }
            let rect: CGRect = self.superview!.convert(self.frame, to: UIApplication.shared.keyWindow)
            let frame = CGRect.init(x: item.x + rect.origin.x, y: item.y + rect.origin.y, width: item.width, height: item.height)
            if frame.contains(curItem.center){
                return item
            }
            
        }
        return nil
    }
    
    /**
     *  删除item
     */
    func delete(_ item: SLFriendDragItem) {
        item.removeFromSuperview()
        //
        items.remove(at: items.firstIndex(of: item) ?? 0)
        
        updateItem()
        
        UIView.animate(withDuration: 0.25) {
            self.updateLaterItemButtonFrame(item.tag)
        }
        
        
        if isFitItemListH{
            var frame = self.frame
            frame.size.height = itemListH
            UIView.animate(withDuration: 0.25) {
                self.frame = frame
            }
        }
        
        deleteItemBlock?(item)
    }
    
    func removeAll() {
        for item in items{
            item.removeFromSuperview()
        }
        //
        items.removeAll()
        updateItem()
        
        
        if isFitItemListH{
            var frame = self.frame
            frame.size.height = itemListH
            UIView.animate(withDuration: 0.25) {
                self.frame = frame
            }
        }
    }
    
    
    // 更新item
    func updateItem(){
        for (index,item) in items.enumerated(){
            item.tag = index
        }
    }
    
    // 更新之前按钮
    func updateBeforeTagButtonFrame(_ beforeI: Int){
        for index in 0..<beforeI{
            updateItemFrame(index, extreMargin: false)
        }
    }
    
    // 更新以后按钮
    func updateLaterItemButtonFrame(_ laterI: Int){
        for index in 0..<self.items.count{
            updateItemFrame(index, extreMargin: false)
        }
    }
    
    func updateItemFrame(_ i: Int, extreMargin: Bool) {
        // 获取当前按钮
        let tagItem = items[i]
        
        setupItemButtonRegularFrame(tagItem)
        
    }
    
    // 计算标签按钮frame（按规律排布）
    func setupItemButtonRegularFrame(_ tagItem: SLFriendDragItem?) {
        // 获取角标
        let i = tagItem?.tag ?? 0
        let col = i % itemListCols
        let row = i / itemListCols
        let btnW = itemSize.width
        let btnH = itemSize.height
        //    NSInteger margin = (self.bounds.size.width - _itemListCols * btnW - 2 * _itemMargin) / (_itemListCols - 1);
        let btnX = CGFloat(col) * (btnW + itemMargin) + itemMargin
        let btnY = CGFloat(row) * (btnH + itemMargin)
        tagItem?.frame = CGRect(x: btnX, y: btnY, width: btnW, height: btnH)
    }
    // MARK: - 底部删除 视图
    lazy var deleteView: UIView = {
        let deleteView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT - kSafeBottomHeight, width: SCREEN_WIDTH, height: deleteViewHeight))
        deleteView.backgroundColor = UIColor.red
        let button = YXSButton(type: .custom)
        button.tag = 201809
        button.setImage(UIImage(named: "wc_drag_delete"), for: .normal)
        button.setImage(UIImage(named: "wc_drag_delete_activate"), for: .selected)
        button.setTitle("拖到此处删除", for: .normal)
        button.setTitle("松手即可删除", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.yxs_setIconInLeftWithSpacing(25)
        deleteView.addSubview(button)
        button.sizeToFit()
        var frame = button.frame
        frame.origin.x = (deleteView.frame.size.width - frame.size.width) / 2
        frame.origin.y = (deleteViewHeight - frame.size.height) / 2 + 5
        button.frame = frame
        
        UIApplication.shared.keyWindow?.addSubview(deleteView)
        return deleteView
    }()
    
    
    func showDeleteViewAnimation() {
        deleteView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.deleteView.transform = self.deleteView.transform.translatedBy(x: 0, y: -self.deleteViewHeight)
            
        }) { finished in
            
        }
    }
    
    func hiddenDeleteViewAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.deleteView.transform = .identity
        }) { finished in
            
        }
    }
    
    func setDeleteViewDeleteState() {
        let button = deleteView.viewWithTag(201809) as? UIButton
        button?.isSelected = true
    }
    
    func setDeleteViewNormalState() {
        let button = deleteView.viewWithTag(201809) as? UIButton
        button?.isSelected = false
    }
    
    func dismissKeyBord() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
