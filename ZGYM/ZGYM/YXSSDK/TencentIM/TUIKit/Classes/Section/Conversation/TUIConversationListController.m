//
//  TUIConversationListController.m
//  TXIMSDK_TUIKit_iOS
//
//  Created by annidyfeng on 2019/5/17.
//

#import "TUIConversationListController.h"
#import "TUIConversationCell.h"
#import "THeader.h"
#import "TUIKit.h"
#import "TUILocalStorage.h"
#import "TIMUserProfile+DataProvider.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "ZGYM-Swift.h"
@import ImSDK;

static NSString *kConversationCell_ReuseId = @"TConversationCell";

@interface TUIConversationListController () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>
@end

@implementation TUIConversationListController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupViews
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    [_tableView registerClass:[TUIConversationCell class] forCellReuseIdentifier:kConversationCell_ReuseId];
//    [_tableView registerClass:[HMSearchSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HMSearchSectionHeaderView"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    @weakify(self)
    [RACObserve(self.viewModel, dataList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}



- (TConversationListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [TConversationListViewModel new];
        
        _viewModel.listFilter = ^BOOL(TUIConversationCellData * _Nonnull data) {
            
            if ([data.convId isEqualToString:@"spy"]) {
                /// 界面层永不显示spy会话
                return false;
            } else {
                return (data.convType != TIM_SYSTEM);
            }
        };
    }
    return _viewModel;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel.dataList[indexPath.row] heightOfWidth:Screen_Width];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        TUIConversationCellData *conv = self.viewModel.dataList[indexPath.row];
        [self.viewModel removeData:conv];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        /// 消除角标数值
        NSInteger count = [self yxs_getBadgeCountOnItemWithIndex:2];
        count = count - conv.unRead;
        [self yxs_showBadgeOnItemWithIndex:2 count:count];
        
        [tableView endUpdates];
    }
}

- (void)didSelectConversation:(TUIConversationCell *)cell
{
    if(_delegate && [_delegate respondsToSelector:@selector(conversationListController:didSelectConversation:)]){
        [_delegate conversationListController:self didSelectConversation:cell];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TUIConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kConversationCell_ReuseId forIndexPath:indexPath];
    cell.backgroundColor = YXSChatHelper.sharedInstance.isNightTheme ? [UIColor yxs_hexToAdecimalColorWithHex:@"#20232F"] : [UIColor whiteColor];
    cell.titleLabel.textColor = YXSChatHelper.sharedInstance.isNightTheme ? [UIColor yxs_hexToAdecimalColorWithHex:@"#FFFFFF"] : [UIColor blackColor];
    
    TUIConversationCellData *data = [self.viewModel.dataList objectAtIndex:indexPath.row];
    if (!data.cselector) {
        data.cselector = @selector(didSelectConversation:);
    }
    
    if ([data.convId isEqualToString:@"assistant"]) {
        ///Custom设置默认头像
        data.avatarImage = [UIImage imageNamed:@"yxs_logo"];
        
        /// 优学业助手 副标题显示消息内容
        TIMConversation *c = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:data.convId];
        TIMMessage *msg = [c getLastMsg];
        if (msg.elemCount && [[msg getElem:0] isMemberOfClass:[TIMCustomElem class]]) {
            TIMCustomElem *ele = (TIMCustomElem *)[msg getElem:0];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:ele.data options:0 error:nil];
            data.subTitle = dic[@"content"];
        }
        [cell fillWithData:data];
        
    } else {
        ///切割&标题
        NSArray *arr = [data.title componentsSeparatedByString:@"&"];
        data.title = arr.lastObject;
        
        if (YXSChatHelper.sharedInstance.isNightTheme) {
            data.avatarImage = [data.convId containsString:@"TEACHER"] ? [UIImage imageNamed:@"yxs_defult_teacher_night"] : [UIImage imageNamed:@"yxs_defult_partent_night"];
            
        } else {
            data.avatarImage = [data.convId containsString:@"TEACHER"] ? [UIImage imageNamed:@"yxs_defult_teacher"] : [UIImage imageNamed:@"yxs_defult_partent"];
        }
        
        [cell fillWithData:data];
    }

    //可以在此处修改，也可以在对应cell的初始化中进行修改。用户可以灵活的根据自己的使用需求进行设置。
//    cell.changeColorWhenTouched = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
           [cell setSeparatorInset:UIEdgeInsetsMake(0, 75, 0, 0)];
        if (indexPath.row == (self.viewModel.dataList.count - 1)) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HMSearchSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HMSearchSectionHeaderView"];
//    return header;
//}

@end
