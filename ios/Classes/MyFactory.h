//
//  MyFactory.h
//  Runner
//
//  Created by yuan on 2019/7/27.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


NS_ASSUME_NONNULL_BEGIN

@interface MyFactory : NSObject <FlutterPlatformViewFactory>

-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end


@interface MyPlatformView : NSObject <FlutterPlatformView>

- (instancetype)platformViewWithArguments:(id _Nullable)args messenger:(nonnull NSObject<FlutterBinaryMessenger> *)messenger viewId:(NSInteger)viewId;

@end


NS_ASSUME_NONNULL_END
