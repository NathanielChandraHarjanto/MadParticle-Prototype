//
//  HelloWorldLayer.h
//  Box2DSwipe
//
//  Created by Tim Roadley on 13/12/11.
//  Copyright Tim Roadley 2011. All rights reserved.
//

#import "cocos2d.h" // So we can use cocos2d
#import "Box2D.h" // So we can use Physics
#import "TRBox2D.h" // So we can use Physcis and cocos2d together easier
#import "GLES-Render.h" // So we can see Physics when in debug mode (see the draw method in the .mm)


@interface HelloWorldLayer : CCLayer
{
	CGSize screenSize; // This is a variable used to do things based on the size of the screen
    
    b2World *world; // This is the physics world
	GLESDebugDraw *debugDraw;  // enable or disable this in the draw method
    
    TRBox2D *ground; // The ground body (used for limiting the world to the screen size)
    TRBox2D *ball;  // This is the physics body tied to a cocos2s sprite
    TRBox2D *Z;
    TRBox2D *backgroundscene;
    TRBox2D *swipe; // This is a small Box2D circle created when you put your finger on the screen
    
    TRBox2D *square1;
    
    b2Fixture *_ZFixture;
    b2Fixture *_ballFixture;


    int screenWidth;
    int screenHeight;
    
   
}

// RETURNS THIS SCENE TO THE APP DELEGATE
+(CCScene *) scene;

@end
