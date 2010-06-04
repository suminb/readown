//
//  MarkdownDocument.m
//  Readown
//
//  Created by Hong, MinHee on 08. 04. 09.
//

#import "MarkdownDocument.h"
#import "Markdown.h"
#import <WebKit/WebKit.h>

@implementation MarkdownDocument
@synthesize webView;

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MarkdownDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)type error:(NSError **)outError
{
	baseURL = [url retain];
	text = [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:outError] retain];

    return YES;
}

- (void)awakeFromNib
{
    [self loadFromBaseURL];
	//[webView setPolicyDelegate:self];
    
    //[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:tempFilePath]]];
}

- (void)loadFromBaseURL {
    text = [NSString stringWithContentsOfURL:baseURL encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:@"<html><body>%@</body></html>", [text stringWithMarkdownAndSmartyPants]];
    
    NSLog(@"%@", html);

    [[webView mainFrame] loadHTMLString:html baseURL:baseURL];
}
    

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
	[listener ignore];
	[[NSWorkspace sharedWorkspace] openURL:[request URL]];
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id<WebPolicyDecisionListener>)listener
{
	[self webView:sender decidePolicyForNavigationAction:actionInformation request:request frame:[webView mainFrame] decisionListener:listener];
}

- (IBAction)reload:(id)sender {
    [self loadFromBaseURL];
    //[[webView mainFrame] reload];
}

- (void)dealloc {
    [baseURL release];
    [super dealloc];
}
@end
