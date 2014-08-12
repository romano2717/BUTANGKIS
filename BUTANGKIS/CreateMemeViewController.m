//
//  CreateMemeViewController.m
//  BUTANGKIS
//
//  Created by Diffy Romano on 8/8/14.
//  Copyright (c) 2014 Diffy Romano. All rights reserved.
//

#import "CreateMemeViewController.h"
#import "THLabel.h"

@interface CreateMemeViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet THLabel *topTextLabel;
@property (nonatomic, weak) IBOutlet THLabel *bottomTextLabel;
@end

@implementation CreateMemeViewController

#define kStrokeColor		[UIColor blackColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 5.0 : 2.0)

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
    
    //set image
    self.imageView.image = image;
    
    self.topTextLabel.strokeColor = kStrokeColor;
    self.topTextLabel.strokeSize = kStrokeSize;
    
    self.bottomTextLabel.strokeColor = kStrokeColor;
    self.bottomTextLabel.strokeSize = kStrokeSize;
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
