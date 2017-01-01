//
//  MK_DismissSegue.m
//  Oblique™
//
//     /^\˛˛˛˛˛˛˛/^\
//     /« ´ˆˆˆˆˆ` »\
//     |«´¸     ¸`»|
//     {  e     e  }
//     \    (∞)    /
//      |\ `-^-´ /|
//      |  ¨¨¨¨¨  |
//      |         |
//     /    ≈≈≈    \
//     /   ≈≈≈≈≈   \
//    /   ≈≈≈≈≈≈≈   \
//    |  ≈≈≈≈≈≈≈≈≈  |
//
//
//  by Masood Kamandy
//  © 2016 All Rights Reserved
//
//  Last updated 12/31/2016
//
//  More information at masoodkamandy@gmail.com

#import "MK_DismissSegue.h"
#import "ViewController.h"

@implementation MK_DismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [(ViewController *)sourceViewController.presentingViewController.childViewControllers[1] toggleVisibilityOfButtons];
    
}


@end
