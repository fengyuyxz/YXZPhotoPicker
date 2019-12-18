//
//  ViewController.m
//  YXZPhotoPicker
//
//  Created by 颜学宙 on 2019/12/18.
//  Copyright © 2019 颜学宙. All rights reserved.
//

#import "ViewController.h"
#import "YxzPhotoPicker.h"
@interface ViewController ()
@property(nonatomic,strong)YxzPhotoPicker *picker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)butPresend:(id)sender {
    _picker=[[YxzPhotoPicker alloc]init];
    [_picker pickerPhoto:self withAllowsEdit:YES completion:^(BOOL isSUC, UIImage * _Nullable image,NSString *iageType) {
        
    }];
}


@end
