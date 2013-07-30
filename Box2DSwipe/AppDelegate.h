//
//  AppDelegate.h
//  Box2DSwipe
//
//  Created by Tim Roadley on 13/12/11.
//  Copyright Tim Roadley 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
