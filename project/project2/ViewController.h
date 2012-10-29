//
//  ViewController.h
//  project2
//
//  Created by annutech on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewAdditions.h"

@interface ViewController : UIViewController<UIWebViewDelegate>{
    
    IBOutlet UIWebView *web;
    IBOutlet UITextView *text;
    IBOutlet UIActivityIndicatorView *active;
    
}

@property(nonatomic,retain)IBOutlet UIWebView *web;

-(IBAction)close;

@end
