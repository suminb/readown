//
//  Markdown.h
//  Readown
//
//  Created by Hong, MinHee on 08. 04. 12.
//

#import <Foundation/NSString.h>

NSString *Markdown(NSString *);
NSString *SmartyPants(NSString *);

@interface NSString (Markdown)

- (NSString*)stringWithMarkdown;
- (NSString*)stringWithSmartyPants;
- (NSString*)stringWithMarkdownAndSmartyPants;

@end