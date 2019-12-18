//
//  YxzPhotoPicker.m
//  YXZPhotoPicker
//
//  Created by 颜学宙 on 2019/12/18.
//  Copyright © 2019 颜学宙. All rights reserved.
//

#import "YxzPhotoPicker.h"
#import <AVFoundation/AVFoundation.h>
@interface YxzPhotoPicker()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,copy)PhotoCompletionBlock block;
@property(nonatomic,weak)UIViewController *parentVC;
@property(nonatomic,assign)BOOL allowsEdit;
@end
@implementation YxzPhotoPicker
-(void)pickerPhoto:(UIViewController *)parentVC withAllowsEdit:(BOOL)allowsEdit completion:(PhotoCompletionBlock)block{
    self.parentVC=parentVC;
    self.block = block;
    self.allowsEdit=allowsEdit;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus==AVAuthorizationStatusNotDetermined){//用户还未做出选择
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
              dispatch_sync(dispatch_get_main_queue(), ^{
                  [self actionSheet];
              });
          }
        }];
    }else if(AVAuthorizationStatusDenied==authStatus){//用户拒绝
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:@"需要您的同意才能打开摄像" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
             
            if (@available(iOS 10.0, *)){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            
            
        }];
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf=weakSelf;
            if (strongSelf.block) {
                strongSelf.block(NO, nil,nil);
            }
            strongSelf.parentVC=nil;
        }];
        [alertController addAction:cancel];
        [alertController addAction:action];
        [parentVC presentViewController:alertController animated:YES completion:nil];
    }else{
        [self actionSheet];
    }
}
-(UIImagePickerController *)imagePickerController{
    UIImagePickerController *pickerVC=[[UIImagePickerController alloc]init];
    pickerVC.allowsEditing=self.allowsEdit;
    pickerVC.delegate=self;
    pickerVC.modalPresentationStyle=UIModalPresentationFullScreen;
    return pickerVC;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}
-(void)actionSheet{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //牌照
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf=weakSelf;
            [strongSelf showImagePicker:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertController addAction:action];
    }
    //相册
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIAlertAction *action=[UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf=weakSelf;
            [strongSelf showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [alertController addAction:action];
    }
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf=weakSelf;
        if (strongSelf.block) {
            strongSelf.block(NO, nil,nil);
        }
        strongSelf.parentVC=nil;
    }];
    [alertController addAction:action];
    [self.parentVC presentViewController:alertController animated:YES completion:nil];
}
-(void)showImagePicker:(UIImagePickerControllerSourceType)type{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    UIImagePickerController *pickerVC=[[UIImagePickerController alloc]init];
    pickerVC.allowsEditing=self.allowsEdit;
    pickerVC.delegate=self;
    pickerVC.modalPresentationStyle=UIModalPresentationFullScreen;
    pickerVC.sourceType=type;
    [self.parentVC presentViewController:pickerVC animated:YES completion:nil];
}
/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    NSString *type;
    NSURL *url=[info objectForKey:@"UIImagePickerControllerReferenceURL"];
    if (url) {
         type = url.path;
      NSRange rg=  [type rangeOfString:@"."];
      type=  [[type substringWithRange:NSMakeRange(rg.location+1, type.length-rg.location-1)] lowercaseString];
        NSLog(@"%@",type);
    }else{
        type=@"jpg";
    }
    UIImage *edt=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (self.block) {
        self.block(YES,edt,type);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    NSString *type;
    NSURL *url=[info objectForKey:@"UIImagePickerControllerReferenceURL"];
    if (url) {
         type = url.path;
      NSRange rg=  [type rangeOfString:@"."];
      type=  [[type substringWithRange:NSMakeRange(rg.location+1, type.length-rg.location-1)] lowercaseString];
        NSLog(@"%@",type);
    }else{
        type=@"jpg";
    }
    UIImage *edt=[info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (self.block) {
        self.block(YES,edt,type);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    if (self.block) {
        self.block(NO, nil,nil);
    }
    self.parentVC=nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
