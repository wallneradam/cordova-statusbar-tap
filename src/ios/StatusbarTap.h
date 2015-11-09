//
//  StatusbarTap.h
//

#import <Cordova/CDVPlugin.h>

@interface StatusbarTap : CDVPlugin <UIScrollViewDelegate> {
    BOOL initialized;
}

- (void)initListener:(CDVInvokedUrlCommand*)command;

@end