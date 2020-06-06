//
//  YXSSolitaireCollectorSetupDetailController.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/5.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import ObjectMapper
import NightNight

class YXSSolitaireCollectorSetupDetailController: YXSBaseTableViewController {
    var dataSource: [YXSClassMemberModel] = [YXSClassMemberModel]()

    var censusId: Int
    var gatherId: Int
    var option: String?
    var gatherTopicId: Int
    var type: YXSQuestionType
    var classId: Int
    init(censusId: Int, gatherId: Int, gatherTopicId: Int, option: String?, type: YXSQuestionType, classId: Int) {
        self.censusId = censusId
        self.gatherId = gatherId
        self.classId = classId
        self.gatherTopicId = gatherTopicId
        self.option = option
        self.type = type
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(YXSSolitaireCollectorSetupDetailBaseCell.self, forCellReuseIdentifier: "YXSSolitaireCollectorSetupDetailBaseCell")
        self.tableView.estimatedRowHeight = 150
    }
    
    
    override func yxs_refreshData() {
        loadData()
    }
    
    override func yxs_loadNextPage() {
        loadData()
    }
    
    // MARK: - Request
    
    func loadData(){
        YXSEducationCensusTeacherGatherItemPersonnelListRequest(currentPage: currentPage, gatherId: gatherId, censusId: censusId, gatherTopicId: gatherTopicId, option: option).request({ (result) in
            
            let list = Mapper<YXSClassMemberModel>().mapArray(JSONString: result["list"].rawString()!) ?? [YXSClassMemberModel]()
            
            self.yxs_endingRefresh()
            if self.currentPage == 1{
                self.dataSource.removeAll()
            }
            self.loadMore = result["hasNext"].boolValue
            self.dataSource += list
            
            self.tableView.reloadData()
        }) { (msg, code) in
            self.yxs_endingRefresh()
            MBProgressHUD.yxs_showMessage(message: msg)
        }
    }
   
    // MARK: - Setter

    
    // MARK: - Action
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YXSSolitaireCollectorSetupDetailBaseCell", for: indexPath) as! YXSSolitaireCollectorSetupDetailBaseCell
        let model = dataSource[indexPath.row]
        cell.setCellModel(model: model, type: type)
        cell.callClickBlock = {
            [weak self] (isChatClick) in
            guard let strongSelf = self else { return }
            if isChatClick{
                UIUtil.yxs_chatImRequest(childrenId: model.childrenId ?? 0, classId: strongSelf.classId)
            }else{
                UIUtil.yxs_callPhoneNumberRequest(childrenId: model.childrenId ?? 0, classId: strongSelf.classId)
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .image{
            let model = dataSource[indexPath.row]
            let vc = YXSSolitaireCollectorSetupImageDetailController()
            vc.classModel = model
            vc.title = "\(model.realName ?? "")\(model.relationship?.yxs_RelationshipValue() ?? "")"
            self.navigationController?.pushViewController(vc)
        }
    }
}

class  YXSSolitaireCollectorSetupImageDetailController: YXSBaseViewController{
    var classModel: YXSClassMemberModel?{
        didSet{
            var medias = [YXSFriendsMediaModel]()
            let imgUrls = (classModel?.option ?? "").components(separatedBy: ",")
            for imgurl in imgUrls{
                if !imgurl.isEmpty{
                    let meidaModel = YXSFriendsMediaModel(url: imgurl, type: .serviceImg)
                    medias.append(meidaModel)
                }
            }
            nineMediaView.medias = medias
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(nineMediaView)
            nineMediaView.snp.makeConstraints({ (make) in
            make.top.equalTo(17)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
    }
    
    lazy var nineMediaView: YXSNineMediaView = {
        let nineMediaView = YXSNineMediaView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 0), imageMaxCount: 9)
        nineMediaView.edges = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        return nineMediaView
    }()
    
}
