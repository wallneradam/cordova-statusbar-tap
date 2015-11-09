//
//  StatusbarTap.m
//

#import "StatusbarTap.h"

@implementation StatusbarTap {
    UIWebView *webView;
}

- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView {
    self = [super initWithWebView:theWebView];
    if (self) {
        initialized = NO;
        webView = theWebView;
    }
    return self;
}


/**
 * Just a helper function to determine why scrollsToTop not working
 */
- (void)removeScrollsToTop:(UIView *)v {
    if ([v isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollView = (UIScrollView*)v;
        if (scrollView.scrollsToTop) {
            scrollView.scrollsToTop = NO;
        }
    }
    
    for (UIView *sv in [v subviews]) {
        [self removeScrollsToTop:sv];
    }
}

- (void)initListener:(CDVInvokedUrlCommand*)command {
    if (!initialized) {
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        [self removeScrollsToTop:w.rootViewController.view];

        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 10000, 0)];
        sv.contentSize = CGSizeMake(10000, 1);
        sv.backgroundColor = [UIColor clearColor];
        sv.contentOffset = CGPointMake(0, 1);
        sv.delegate = self;
        sv.scrollsToTop = YES;
        
        [webView.superview addSubview:sv];
    }
    initialized = YES;
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [webView stringByEvaluatingJavaScriptFromString:@"var evt = document.createEvent(\"Event\"); evt.initEvent(\"statusbarTap\",true,true); window.dispatchEvent(evt);"];
    return NO;
}

@end