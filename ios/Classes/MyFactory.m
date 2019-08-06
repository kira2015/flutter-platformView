//
//  MyFactory.m
//  Runner
//
//  Created by yuan on 2019/7/27.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "MyFactory.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation MyFactory{
    NSObject<FlutterBinaryMessenger> *_messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    if (self = [super init]) {
        _messenger = messenger;
    }
    return self;
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {

    MyPlatformView *view = [[MyPlatformView new] platformViewWithArguments:args messenger:_messenger viewId:viewId];
    return view;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec{
    return  [FlutterStandardMessageCodec sharedInstance];
}

@end




@implementation MyPlatformView{
    UIView *_view;
    NSInteger _counter;
    NSObject<FlutterBinaryMessenger> * _messenger;
    UILabel *_showLabel;
    MBProgressHUD *_hud;
    NSInteger _viewId;
}

- (instancetype)platformViewWithArguments:(id _Nullable)args messenger:(nonnull NSObject<FlutterBinaryMessenger> *)messenger viewId:(NSInteger)viewId{
    _viewId = viewId;
    _counter = [args[@"counter"] integerValue];
    _messenger = messenger;
    [self setupWithUI];
    [self setupMethodChannel:[NSString stringWithFormat:@"flutter_ios_counter_%ld",(long)viewId]] ;
    return self;
   
}

-(void)setupWithUI{
    
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    vv.backgroundColor = [UIColor yellowColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 60)];
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"原生控件内容counter:%ld",(long)_counter];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor lightGrayColor];
    [vv addSubview:label];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 80, 100, 50)];
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"原生按钮+1" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [vv addSubview:button];
    
    
    
    _view = vv;
    _showLabel = label;
    

}
- (UIView*)view{
    
    return _view;
}

-(void)clickBtn{
    _counter++;
    _showLabel.text = [NSString stringWithFormat:@"原生控件内容\ncounter:%ld",_counter];
    NSLog(@"ios-->%ld",_counter);
    FlutterMethodChannel *channel_sender = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"flutter_ios_counter_receive_%ld",(long)self->_viewId] binaryMessenger:_messenger];
    [channel_sender invokeMethod:@"counter_method" arguments:@(_counter)];
    
}

-(void)clickHUD{
    NSLog(@"HUD:%d",_hud.hidden);
    
    
}

- (void)setupMethodChannel:(NSString*)channelName{

    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:_messenger];
    //监听
    [channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {

        if ([call.method isEqualToString:@"counter_method"]) {
            
            self->_counter = [call.arguments integerValue];
            self->_showLabel.text = [NSString stringWithFormat:@"原生控件内容\ncounter:%ld",self->_counter];
        }else if([call.method isEqualToString:@"pods_method"]){
            if (self->_hud==nil) {
                self->_hud =  [MBProgressHUD showHUDAddedTo:self->_view animated:YES];
            }else{
                [self->_hud hideAnimated:YES];
                self->_hud = nil;
            }
        }
    }];
}
@end
