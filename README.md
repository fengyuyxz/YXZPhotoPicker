相机中，取消、使用等按钮文字语言根据系统而定需在，工程info.plist中添加CFBundleAllowMixedLocalizations 设置YES
-(void)pickerPhoto:(UIViewController *)parentVC withAllowsEdit:(BOOL)allowsEdit completion:(PhotoCompletionBlock)block;
parentVC为必传