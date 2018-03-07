//
//  RITLPhotosGroupTableViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosGroupTableViewController.h"

#import "RITLPhotosGroupCell.h"

#import "PHAssetCollection+RITLPhotos.h"
#import "PHPhotoLibrary+RITLPhotoStore.h"

#import <RITLKit.h>


@interface RITLPhotosGroupTableViewController (AssetData)

/// 加载默认的组
- (void)loadDefaultAblumGroups;

@end

@interface RITLPhotosGroupTableViewController (RITLString)

- (NSAttributedString *)titleForCollection:(PHAssetCollection *)collection count:(NSInteger)count;

@end


@interface RITLPhotosGroupTableViewController ()

@property (nonatomic, copy)NSArray <PHAssetCollection *> *groups;

@end

@implementation RITLPhotosGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigationItem
    self.navigationItem.title = @"照片";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPhotoControllers)];
    
    //data
    self.groups = @[];
    
    //tableView
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //cell
    [self.tableView registerClass:RITLPhotosGroupCell.class forCellReuseIdentifier:@"group"];
    
    //获取数据
    [self loadDefaultAblumGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Dismiss

- (void)dismissPhotoControllers
{
    if(self.navigationController.presentingViewController){//如果是模态弹出
        
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        
    }else if(self.navigationController){
        
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RITLPhotosGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"group" forIndexPath:indexPath];
    
    // Configure the cell...
    PHAssetCollection *collection = self.groups[indexPath.row];
    
    [collection ritl_headerImageWithSize:CGSizeMake(30, 30) mode:PHImageRequestOptionsDeliveryModeOpportunistic complete:^(NSString * _Nonnull title, NSUInteger count, UIImage * _Nullable image) {
        
        //set value
        cell.titleLabel.attributedText = [self titleForCollection:collection count:count];
        cell.imageView.image = image;
        
    }];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end




@implementation RITLPhotosGroupTableViewController (AssetData)

- (void)loadDefaultAblumGroups
{
    [PHPhotoLibrary.sharedPhotoLibrary fetchAlbumRegularGroupsByUserLibrary:^(NSArray<PHAssetCollection *> * _Nonnull groups) {
       
        //set
        self.groups = groups;
        
        if (NSThread.isMainThread) {
            [self.tableView reloadData];//reload
        }else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
        }
    }];
}

@end




@implementation RITLPhotosGroupTableViewController (RITLString)

- (NSAttributedString *)titleForCollection:(PHAssetCollection *)collection count:(NSInteger)count
{
    //数据拼接
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:collection.localizedTitle
                                  attributes:@{NSFontAttributeName: RITLUtilityFont(RITLFontPingFangSC_Medium, 15)}];
    
    if (count < 0 || count == NSNotFound) {
        
        count = 0;
    }
    
    //
    NSString *countString = [NSString stringWithFormat:@"  (%@)",@(count).stringValue];
    
    //数量
    NSMutableAttributedString *countResult = [[NSMutableAttributedString alloc]
                                       initWithString:countString
                                              attributes:@{NSFontAttributeName: RITLUtilityFont(RITLFontPingFangSC_Medium, 15),NSForegroundColorAttributeName:RITLColorSimpleFromIntRBG(102)}];
    
    [result appendAttributedString:countResult];
    
    return result;
}

@end