//
//  Markdown.m
//  Readown
//
//  Created by Hong, MinHee on 08. 04. 12.
//

#import "Markdown.h"
#import <Cocoa/Cocoa.h>

NSString *__markdown_run_php_script(NSString *text, NSString* bundleName)
{
	NSTask *task = [[[NSTask alloc] init] autorelease];
	NSPipe *inPipe = [NSPipe pipe], *outPipe = [NSPipe pipe];
	NSFileHandle	*inHandle = [inPipe fileHandleForWriting],
					*outHandle = [outPipe fileHandleForReading];
	NSData *outData = nil;
	
	[task setLaunchPath:@"/usr/bin/env"];
	
	[task setArguments:
		[NSArray arrayWithObjects:
			@"php",
			[[NSBundle mainBundle] pathForResource:bundleName ofType:@"php"],
			nil
		]
	];

	[task setStandardInput:inPipe];
	[task setStandardOutput:outPipe];
	[task setStandardError:outPipe];
	
	[task launch];

	[inHandle writeData:[text dataUsingEncoding:NSUTF8StringEncoding]];
	[inHandle closeFile];
	
	outData = [outHandle readDataToEndOfFile];
	[outHandle closeFile];

	[task waitUntilExit];

	if(outData) {
		text = [
			[[NSString alloc]
				initWithData:outData
				encoding:NSUTF8StringEncoding
			] autorelease
		];

		if(text)
			return text;
	}
	
	return @"";
}

NSString *Markdown(NSString *text)
{
	return __markdown_run_php_script(text, @"Markdown");
}

NSString *SmartyPants(NSString *text)
{
	return __markdown_run_php_script(text, @"SmartyPants");
}

@implementation NSString (Markdown)

- (NSString*)stringWithMarkdown
{
	return Markdown(self);
}

- (NSString*)stringWithSmartyPants
{
	return SmartyPants(self);
}

- (NSString*)stringWithMarkdownAndSmartyPants
{
	return SmartyPants(Markdown(self));
}

@end