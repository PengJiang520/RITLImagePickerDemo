//
//  RITLPhotoRequestStore.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoRequestStore.h"

#import "PHImageRequestOptions+RITLPhotoRepresentation.h"

@implementation RITLPhotoRequestStore


+(void)imagesWithAssets:(NSArray<PHAsset *> *)assets
                 status:(BOOL *)status
                   Size:(CGSize)size
             ignoreSize:(BOOL)isIgnoreSize
               complete:(nonnull void (^)(NSArray<UIImage *> * _Nonnull))imagesBlock

{
     __block NSMutableArray <UIImage *> * images = [NSMutableArray arrayWithCapacity:assets.count];
    
    for (NSUInteger i = 0; i < assets.count; i++)
    {
        //获取资源
        PHAsset * asset = assets[i];
        
        if (isIgnoreSize)
        {
            size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        }
        
        //获取图片类型
//        PHImageRequestOptionsDeliveryMode mode = status[i] ? PHImageRequestOptionsDeliveryModeHighQualityFormat : PHImageRequestOptionsDeliveryModeOpportunistic;
        
        PHImageRequestOptions * option = [PHImageRequestOptions imageRequestOptionsWithDeliveryMode:PHImageRequestOptionsDeliveryModeOpportunistic];
        option.synchronous = true;
        
        //请求图片
        [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [images addObject:result];
            
            if (images.count == assets.count)//表示已经添加完毕
            {
                //回调
                imagesBlock([images mutableCopy]);
            }
        }];
    }    
}


@end