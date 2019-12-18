//
//  YxzPhotoPicker.h
//  YXZPhotoPicker
//
//  Created by 颜学宙 on 2019/12/18.
//  Copyright © 2019 颜学宙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface YxzPhotoPicker : NSObject
//isSUC NO用户取消，或为授权，YES用户选择
typedef void(^PhotoCompletionBlock)(BOOL isSUC, UIImage *__nullable image,NSString *__nullable imageType);

/// 调用相册，相机方法
/// @param parentVC  presentViewControllerd方法调用者，必须传
/// @param allowsEdit 选择相册，和拍照后是否可编辑
/// @param block 回调block
-(void)pickerPhoto:(UIViewController *)parentVC withAllowsEdit:(BOOL)allowsEdit completion:(PhotoCompletionBlock)block;
@end

NS_ASSUME_NONNULL_END
