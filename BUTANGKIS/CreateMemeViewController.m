//
//  CreateMemeViewController.m
//  BUTANGKIS
//
//  Created by Diffy Romano on 8/8/14.
//  Copyright (c) 2014 Diffy Romano. All rights reserved.
//

#import "CreateMemeViewController.h"

@interface CreateMemeViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *topTextView;
@property (nonatomic, weak) IBOutlet UITextView *bottomTextView;
@end

@implementation CreateMemeViewController

@synthesize image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.imageView.image = image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)post
{

}

@end
