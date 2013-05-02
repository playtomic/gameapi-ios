//
//  PlaytomicViewController.m
//  Playtomic iOS API
//
//  Created by Ben Lowry on 4/30/13.
//  Copyright (c) 2013 Ben Lowry. All rights reserved.
//

#import "PlaytomicViewController.h"
#import "Playtomic.h"

@interface PlaytomicViewController ()

@end

@implementation PlaytomicViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [Playtomic initWithPublicKey:@"testpublickey" andPrivateKey:@"testprivatekey" andAPIURL:@"http://127.0.0.1:3000/"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
