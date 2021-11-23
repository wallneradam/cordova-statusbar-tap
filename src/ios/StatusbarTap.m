//
//  StatusbarTap.m
//

#import "StatusbarTap.h"
#import <WebKit/WebKit.h>

@implementation StatusbarTap {
}


/**
 * Disable scrollsToTop is all scrollViews to be able to use our own fake scrollview)
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
		// Disable scrollsToTops
        UIWindow *w = [[UIApplication sharedApplication] keyWindow];
        [self removeScrollsToTop:w.rootViewController.view];

		// Create a dummy UIScrollView
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 10000, 0)];
        sv.contentSize = CGSizeMake(10000, 1);
        sv.backgroundColor = [UIColor clearColor];
        sv.contentOffset = CGPointMake(0, 1);
        sv.delegate = self;
        sv.scrollsToTop = YES;

		// Add it to the webView as a subView
        [self.webView.superview addSubview:sv];

        initialized = YES;
    }
}

/**
 * Detecting statusbar taps
 */
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    // Callback JS on statusbar tap
    NSString *js = @"var evt = document.createEvent(\"Event\"); evt.initEvent(\"statusbarTap\",true,true); window.dispatchEvent(evt);";
    #if !WK_WEB_VIEW_ONLY
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView *)self.webView stringByEvaluatingJavaScriptFromString:js];
    } else {
    #endif
        [(WKWebView *)self.webView evaluateJavaScript:js completionHandler:nil];
    #if !WK_WEB_VIEW_ONLY
    }
    #endif
    return NO;
}

@end
