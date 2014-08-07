//
//  ViewController.h
//  BUTANGKIS
//
//  Created by Diffy Romano on 5/8/14.
//  Copyright (c) 2014 Diffy Romano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)ALAssetsLibrary *library;

@end
