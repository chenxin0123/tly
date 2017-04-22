//
//  ViewController.m
//  tly
//
//  Created by CX on 22/04/2017.
//  Copyright © 2017 cx. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic, strong) CMMotionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *v = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    v.frame = CGRectMake(50, 50, 450, 240);
    v.image = [UIImage imageNamed:@"61e1e24b5cf4a4f36fa8859e1dc35fb6"];
    v.contentMode = UIViewContentModeScaleAspectFill;
    
    _manager = [[CMMotionManager alloc] init];
    [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        CMAttitude *attr = motion.attitude;
        CGFloat roll = attr.roll;
        CGFloat yaw = attr.yaw;
        CGFloat pitch = attr.pitch;
        
        
        NSLog(@"\nroll(%@) pitch(%@) yaw(%@) \n",@(roll * 180 / M_PI),@(pitch * 180 / M_PI),@(yaw  * 180 / M_PI));
        
        CGFloat f = 0.5;
        CGFloat ty = (pitch+yaw) * f;
        roll *= f;
//        pitch *= f;
//        yaw *= f;
        
        ty = ty < 0 ? MAX(-M_PI_4, ty) : MIN(ty, M_PI_4);
        NSLog(@"ty%@ -> %@",@((pitch+yaw) * f * 180 / M_PI),@(ty * 180 / M_PI));
        CATransform3D tr = CATransform3DIdentity;
        tr.m34 = -1 / 2000;
        tr = CATransform3DRotate(tr, roll, 1, 0, 0);
        tr = CATransform3DRotate(tr, ty, 0, 1, 0);
//        tr = CATransform3DRotate(tr, yaw, 0, 0, 1);
        v.layer.transform = tr;
    }];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
   }


- (void)orientationChanged:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
            case UIDeviceOrientationPortrait:
                NSLog(@"UIDeviceOrientationPortrait");
            break;
            case UIDeviceOrientationPortraitUpsideDown:
                NSLog(@"UIDeviceOrientationPortraitUpsideDown");
            break;
            case UIDeviceOrientationLandscapeLeft:
                NSLog(@"UIDeviceOrientationLandscapeLeft");
            break;
            case UIDeviceOrientationLandscapeRight:
                NSLog(@"UIDeviceOrientationLandscapeRight");
            break;
            case UIDeviceOrientationFaceUp:
                NSLog(@"UIDeviceOrientationFaceUp");
            break;
            case UIDeviceOrientationFaceDown:
                NSLog(@"UIDeviceOrientationFaceDown");
            break;
            default:
                NSLog(@"default");
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
