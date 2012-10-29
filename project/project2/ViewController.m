//
//  ViewController.m
//  project2
//
//  Created by annutech on 27/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize web;


-(IBAction)close
{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super viewDidLoad];
	NSURL *theURL = [NSURL URLWithString:@"http://www.google.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:theURL];
    [self.web loadRequest:request];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];


    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];

}

- (void)openContextualMenuAt:(CGPoint)pt
{
    // Load the JavaScript code from the Resources and inject it into the web page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [web stringByEvaluatingJavaScriptFromString: jsCode];
    
    // get the Tags at the touch location
    NSString *tags = [web stringByEvaluatingJavaScriptFromString:
                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    // create the UIActionSheet and populate it with buttons related to the tags
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Contextual Menu"
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil otherButtonTitles:nil];
    
    // If a link was touched, add link-related buttons
    if ([tags rangeOfString:@",A,"].location != NSNotFound) {
        [sheet addButtonWithTitle:@"Open Link"];
        [sheet addButtonWithTitle:@"Open Link in Tab"];
        [sheet addButtonWithTitle:@"Download Link"];
    }
    // If an image was touched, add image-related buttons
    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
        [sheet addButtonWithTitle:@"Save Picture"];
    }
    // Add buttons which should be always available
    [sheet addButtonWithTitle:@"Save Page as Bookmark"];
    [sheet addButtonWithTitle:@"Open Page in Safari"];
    
    [sheet showInView:web];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];

 
}

         
- (void)contextualMenuAction:(NSNotification*)notification
{
    CGPoint pt;
    NSDictionary *coord = [notification object];
    pt.x = [[coord objectForKey:@"x"] floatValue];
    pt.y = [[coord objectForKey:@"y"] floatValue];
    
    // convert point from window to view coordinate system
    pt = [web convertPoint:pt fromView:nil];
    
    // convert point from view to HTML coordinate system
    CGPoint offset  = [web scrollOffset];
    CGSize viewSize = [web frame].size;
    CGSize windowSize = [web windowSize];
    
    CGFloat f = windowSize.width / viewSize.width;
    pt.x = pt.x * f + offset.x;
    pt.y = pt.y * f + offset.y;
    
    [self openContextualMenuAt:pt];
}
    
    

           

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
