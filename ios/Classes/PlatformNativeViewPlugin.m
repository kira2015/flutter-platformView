
#import "PlatformNativeViewPlugin.h"
#import "MyFactory.h"

@implementation PlatformNativeViewPlugin

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    //开始启动插件--接入Factory
    MyFactory *factory = [[MyFactory alloc]initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"plugins.native.view"];
    
}

@end
