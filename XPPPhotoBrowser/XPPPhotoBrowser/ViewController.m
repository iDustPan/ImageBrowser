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
    return 300;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XPPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
    NSArray *photos = @[
                        @"https://ae01.alicdn.com/kf/HTB1H.n8PXXXXXbcXpXXq6xXFXXX1/-font-b-Sexy-b-font-font-b-Girls-b-font-Women-Summer-Sleeveless-Spaghetti-Straps.jpg",
                        @"http://www.chinajinci.com/uploadfile/2011/0422/20110422110403873.jpg",
                        @"https://media3.giphy.com/media/af2dfzlfxxdok/200_s.gif",
                        @"https://image.winudf.com/v2/image/Y29tLmFtYXRldXIuc2V4eWhvdGdpcmxfc2NyZWVuc2hvdHNfMl8xMjNiYmQwMQ/screen-2.jpg?h=355&fakeurl=1&type=.jpg",
                        @"https://www.dhresource.com/albu_1026794021_00-1.0x0/wholesale-hot-striped-bikini-women-39-s-3pcs.jpg",
                        @"https://ae01.alicdn.com/kf/HTB1H.n8PXXXXXbcXpXXq6xXFXXX1/-font-b-Sexy-b-font-font-b-Girls-b-font-Women-Summer-Sleeveless-Spaghetti-Straps.jpg",
                        @"https://media3.giphy.com/media/af2dfzlfxxdok/200_s.gif",
                        @"http://www.my10e.com.cn/UploadFile/image/20130117/20130117143711_7968.jpg",
                        @"https://www.dhresource.com/albu_1026794021_00-1.0x0/wholesale-hot-striped-bikini-women-39-s-3pcs.jpg"
                        
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
