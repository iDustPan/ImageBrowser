//
//  ViewController.m
//  XPPPhotoBrowser
//
//  Created by 徐攀 on 2017/8/17.
//  Copyright © 2017年 com.borderXLab. All rights reserved.
//




#import "ViewController.h"
#import "XPPPhotoView.h"
#import <JSONModel.h>
#import "XPPTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[XPPTableViewCell class] forCellReuseIdentifier:@"reuseCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XPPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    NSArray *photos = @[
                        @"http://haul-dev.oss-cn-beijing.aliyuncs.com/img/hf/f837f02b-3252-46a5-af59-c7d69579cb49",
                        @"http://haul-dev.oss-cn-beijing.aliyuncs.com/img/ht/f837f02b-3252-46a5-af59-c7d69579cb49",
                        @"http://haul-dev.oss-cn-beijing.aliyuncs.com/img/hf/1220171b-b3f1-49e8-a104-2d6f682d69ca",
                        @"http://haul-dev.oss-cn-beijing.aliyuncs.com/img/ht/81fa4e2a-929b-42d5-901d-046f58c85367",
                        @"https://bxl-dev.ipinyou.com/pt/ca970860-168d-845f-2a68-6bf5cc29285b.jpg"
                        ];
    cell.photos = photos;
    return cell;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)prepareData {
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"photos" withExtension:@"json"];
    
}



@end
