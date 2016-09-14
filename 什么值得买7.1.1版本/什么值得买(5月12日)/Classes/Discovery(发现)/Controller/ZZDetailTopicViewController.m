//
//  ZZDetailTopicViewController.m
//  什么值得买
//
//  Created by Wang_ruzhou on 16/9/11.
//  Copyright © 2016年 Wang_ruzhou. All rights reserved.
//

#import "ZZDetailTopicViewController.h"
#import "ZZChannelID.h"
#import "ZZDetailTopicHeaderView.h"
#import "ZZDetailTopicCell.h"

static NSString *const kDetailTopicCell = @"detailTopicCell";

@interface ZZDetailTopicViewController ()<ZZDetailTopicHeaderViewDelegate>

@property (nonatomic, strong) ZZDetailTopicHeaderLayout *detailTopicHeaderLayout;

@property (nonatomic, copy) NSString *order;

@end

@implementation ZZDetailTopicViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"话题详情";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"SM_Detail_BackSecond"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(detailLeftBtnDidClick)];
    
    // 后退按钮距离图片距离左边边距
    UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedItem.width = -20;
    self.navigationItem.leftBarButtonItems = @[fixedItem,backItem];

    
    self.navigationItem.rightBarButtonItem = nil;
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.order = kOrderByHot;
    

    [self.tableView registerClass:[ZZDetailTopicCell class] forCellReuseIdentifier:kDetailTopicCell];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:kGlobalLightGrayColor];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
}

#pragma mark - 请求数据

- (void)loadData{
    ZZChannelID *channel = [ZZChannelID channelWithID:_channelID];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@/%@", channel.URLString, _article_id];
    [ZZNetworking Get:URLStr parameters:[NSMutableDictionary dictionary] complectionBlock:^(id responseObject, NSError *error) {
        if (error) { return;}
        
        ZZDetailTopicHeaderModel *detailModel = [ZZDetailTopicHeaderModel modelWithDictionary:responseObject];
        _detailTopicHeaderLayout = [[ZZDetailTopicHeaderLayout alloc] initWithHeaderDetailModel:detailModel];
        
        ZZDetailTopicHeaderView *headerView = [[ZZDetailTopicHeaderView alloc] init];
        headerView.detailTopicHeaderLayout = _detailTopicHeaderLayout;
        headerView.delegate = self;
        self.tableView.tableHeaderView = headerView;
        
    }];

    [self loadContentData];
    
}

- (void)loadContentData{
    // v2/wiki/comments
    
    [ZZNetworking Get:@"v2/wiki/comments" parameters:[self configureParameters] complectionBlock:^(id responseObject, NSError *error) {
        
        NSArray *dataArray = responseObject[@"comment_list"];
        if (error || dataArray.count == 0) {
            [self.tableView.mj_header endRefreshing];
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *datas = [NSArray modelArrayWithClass:[ZZDetailTopicModel class] json:dataArray];
            NSMutableArray *temArray = [NSMutableArray array];
            for (ZZDetailTopicModel *detailTopicModel in datas) {
                ZZDetailTopicContentLayout *layout = [[ZZDetailTopicContentLayout alloc] initWithContentDetailModel:detailTopicModel];
                [temArray addObject:layout];
            }
            self.dataSource = temArray;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            });
        });
        
    }];
}

- (NSMutableDictionary *)configureParameters{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@", @(self.dataSource.count)] forKey:@"offset"];
    [parameters setValue:_article_id forKey:@"topic_id"];
    [parameters setValue:self.order forKey:@"order"];
    return parameters;
}



- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZZDetailTopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:kDetailTopicCell forIndexPath:indexPath];
    
    ZZDetailTopicContentLayout *layout = self.dataSource[indexPath.row];
    
    topicCell.layout = layout;
    
    return topicCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZZDetailTopicContentLayout *layout = self.dataSource[indexPath.row];
    
    return layout.height;
}

#pragma mark - 事件监听
- (void)detailLeftBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)headerViewDidClickOrderBtn:(ZZDetailTopicHeaderView *)headerView orderStr:(NSString *)orderStr{
    self.order = orderStr;
    
    [self loadContentData];
}


@end
