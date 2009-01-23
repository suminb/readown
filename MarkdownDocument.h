//
//  MarkownDocument.h
//  Readown
//
//  Created by Hong, MinHee on 08. 04. 09.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class WebView;

@interface MarkdownDocument : NSDocument
{
	NSString *text;
	NSURL* baseURL;
	IBOutlet WebView *webView;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)type error:(NSError **)outError;
- (void)awakeFromNib;
- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener;
- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener;

@end
