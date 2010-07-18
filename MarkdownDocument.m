//
//  MarkdownDocument.m
//  Readown
//
//  Created by Hong, MinHee on 08. 04. 09.
//

#import "MarkdownDocument.h"
#import "Markdown.h"
#import <WebKit/WebKit.h>

@interface MarkdownDocument(Private)
- (void)initFSEventStream;
- (BOOL)hasFileModified;
- (void)reloadIfFileModified;
@end

// This is probably a bad design, but I don't know where else to put.
// I'm gonna have to make a view controller or something later on.
@implementation MarkdownDocument(Private)
#pragma mark File system event handlings and other file operations

void fsEventCallback(ConstFSEventStreamRef streamRef,
                     void *userData,
                     size_t numEvents,
                     void *eventPaths,
                     const FSEventStreamEventFlags eventFlags[],
                     const FSEventStreamEventId eventIds[]) {
	
    MarkdownDocument *md = (MarkdownDocument*)userData;
    [md reloadIfFileModified];
    
//	NSLog(@"# of events = %d", numEvents);
//    size_t i;
//	for(i=0; i < numEvents; i++){
//		NSString *str = [(NSArray *)eventPaths objectAtIndex:i];
//		NSLog(@"Filesystem has been modified! %@", str);
//	}
}


- (void)initFSEventStream {
    NSLog(@"Watching %@", [[baseURL path] stringByDeletingLastPathComponent]);    
    
	NSArray *pathsToWatch = [NSArray arrayWithObject:[[baseURL path] stringByDeletingLastPathComponent]];
	FSEventStreamContext context = {0, (void *)self, NULL, NULL, NULL};
	FSEventStreamRef stream;
	CFAbsoluteTime latency = 1.0; // Latency in seconds
	
	/* Create the stream, passing in a callback */
	stream = FSEventStreamCreate(NULL,
								 &fsEventCallback,
								 &context,
								 (CFArrayRef) pathsToWatch,
								 kFSEventStreamEventIdSinceNow, /* Or a previous event ID */
								 (CFAbsoluteTime) latency,
								 kFSEventStreamCreateFlagUseCFTypes
								 );
	
	FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	FSEventStreamStart(stream);
}

- (BOOL)hasFileModified {
    //(NSDictionary *)fileAttributesAtPath:(NSString *)path traverseLink:(BOOL)flag   
    NSDictionary *attributes = [[NSFileManager defaultManager] fileAttributesAtPath:[baseURL path] traverseLink:NO];
    NSDate *modificationDate = [attributes objectForKey:@"NSFileModificationDate"];
    
    if([modificationDate isEqualToDate:lastModified]) {
        return NO;
    }
    else {
        [lastModified release];
        lastModified = [modificationDate retain];
        
        return YES;
    }
}

- (void)reloadIfFileModified {
    if ([self hasFileModified]) {
        NSLog(@"File has been modified. Reloading the page.");
        [self loadFromBaseURL];
    }
}

@end


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
    
    // Watching file system events
    [self initFSEventStream];

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
    NSString *html = nil;

    NSString *filename = [[baseURL path] stringByDeletingPathExtension];
    
    // look for CSS file that has the same file name
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cssPath = [filename stringByAppendingString:@".css"];
    if([fileManager fileExistsAtPath:cssPath]) {
        // TODO: need exception handlings
        NSString *css = [NSString stringWithContentsOfFile:cssPath];
        
        // TODO:
        html = [NSString stringWithFormat:@"<html><head><style>%@</style></head><body>%@</body></html>", css, [text stringWithMarkdownAndSmartyPants]];
    }
    else {
        html = [NSString stringWithFormat:@"<html><body>%@</body></html>", [text stringWithMarkdownAndSmartyPants]];
    }

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
