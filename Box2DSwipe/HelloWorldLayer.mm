//
//  HelloWorldLayer.mm
//  Box2DSwipe
//
//  Created by Tim Roadley on 13/12/11.
//  Copyright Tim Roadley 2011. All rights reserved.
//

#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

// RETURE THIS SCENE
+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// PHYSICS
- (void) limitWorldToScreen {
    ground = [[TRBox2D new] autorelease];
    CGSize size = [ [CCDirector sharedDirector] winSize ];
    [ground createEdgesForWorld:world fromScreenSize:size];
    [self addChild:ground];
}
- (void) setupPhysicsWorld {
    
    b2Vec2 gravity = b2Vec2(kHorizontalGravity, kVerticalGravity); // Set in TRBox2DConstants.h
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    debugDraw = new GLESDebugDraw(PTM_RATIO);
    world->SetDebugDraw(debugDraw);
    uint32 flags = 0;
    flags += b2DebugDraw::e_shapeBit;
    flags += b2DebugDraw::e_jointBit;
    //      flags += b2DebugDraw::e_aabbBit;
    //      flags += b2DebugDraw::e_pairBit;
    //      flags += b2DebugDraw::e_centerOfMassBit;
    debugDraw->SetFlags(flags);
    
    [self limitWorldToScreen];
}
- (void) setupPhysicsBodies {
    
    // You may want to use a spritesheet instead of a sprite file
    // For more info on spritesheets read this : http://timroadley.com/2011/08/19/game-template-part-7-texturepacker-physicseditor/
    // For tutorial simplicity I'll only use a sprite file
    
    CGSize size = [ [CCDirector sharedDirector] winSize ];
    screenWidth = size.width;
    screenHeight = size.height;

    
    
    backgroundscene = [TRBox2D spriteWithFile:@"Detector.png"];

    [backgroundscene setPosition:ccp((screenWidth/2), (screenHeight/2))];
    backgroundscene.scaleX = 0.47;
    backgroundscene.scaleY = 0.47;
    backgroundscene.rotation = 90;
    
    square1 = [TRBox2D spriteWithFile:@"Neutrino no BG.png"];
    square1.scaleX = 0.2;
    square1.scaleY = 0.2;
    [square1 setPosition:ccp(50,50)];
    
    
    ball = [TRBox2D spriteWithFile:@"Gamma.png"];
    ball.scaleX = 0.05;
    ball.scaleY = 0.05;
    [ball setPosition:ccp((screenWidth/2), (screenHeight/2))];
    
    [ball createBodyInWorld:world 
                      b2bodyType:b2_dynamicBody 
                           angle:0.0 
                      allowSleep:false 
                   fixedRotation:false 
                          bullet:true];
    
    
    b2CircleShape circle;
    circle.m_radius = 0.025; // radius in meters

    [ball addFixtureOfShape:&circle
                      friction:1.0
                   restitution:0.5
                       density:100.0
                      isSensor:false];
    
    Z = [TRBox2D spriteWithFile:@"Z.png"];
    Z.scaleX = 0.05;
    Z.scaleY = 0.05;
    [Z setPosition:ccp(100, 100)];
    
    [Z createBodyInWorld:world
                 b2bodyType:b2_dynamicBody
                      angle:0.0
                 allowSleep:false
              fixedRotation:false
                     bullet:true];
    
    
    b2CircleShape circlo;
    circlo.m_radius = 0.025; // radius in meters
    
    [Z addFixtureOfShape:&circlo
                   friction:1.0
                restitution:0.5
                    density:100.0
                   isSensor:false];

    
    [self addChild:backgroundscene];
    [self addChild:square1];
    [self addChild:ball];
    [self addChild:Z];
    
}


- (void) tick: (ccTime) dt {
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -0.06 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
    
    
}
- (void) draw {
    
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    world->DrawDebugData();  // comment this out to get rid of Box2D debug drawing
    
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

// INITIALIZATION
- (id) init {

	if( (self=[super init])) {
		
        [self setIsTouchEnabled:YES];
        CGSize size = [ [CCDirector sharedDirector] winSize ];
        screenWidth = size.width;
        screenHeight = size.height;
        

        
        
        [self setupPhysicsWorld];
        [self setupPhysicsBodies];
        [self schedule: @selector(tick:)];
	}
	return self;
}

// TOUCH HANDLING
- (TRBox2D *)createSwipeBodyAtPosition:(CGPoint)position size:(float)size sprite:(NSString*)sprite angle:(float)angle {
    
    // You may want to use a spritesheet instead of a sprite file
    // For more info on spritesheets read this : http://timroadley.com/2011/08/19/game-template-part-7-texturepacker-physicseditor/
    // For tutorial simplicity I'll only use a sprite file
    
    TRBox2D *body = [TRBox2D spriteWithFile:sprite];  
    
    [body setScale:size];
    [body setPosition:position];
    
    [body createBodyInWorld:world 
                 b2bodyType:b2_dynamicBody 
                      angle:angle 
                 allowSleep:false 
              fixedRotation:true 
                     bullet:true];
    
    b2CircleShape circle;
    circle.m_radius = size;
    
    [body addFixtureOfShape:&circle
                   friction:6.0
                restitution:0.1
                    density:5.0
                   isSensor:false];
    
    [self addChild:body];
    
    return body;
}
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 

    for (UITouch *touch in touches) { 
        
        CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        b2Vec2 touchLocationInWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO); 
            
        if (swipe == NULL) {
            
            swipe = [self createSwipeBodyAtPosition:touchLocation size:0.5 sprite:@"Clear.png" angle:0];
                    
            if (swipe.mouseJoint == NULL) {
                
                [swipe createMouseJointInWorld:world groundBody:ground.body target:touchLocationInWorld maxForce:1000.0];
            }
        }
        else {   
            CCLOG(@"This short code does not handle multi touch. You'll need touch hashes for multi touch.");
        }            
    }
}
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
        
    for (UITouch *touch in touches) { 
            
        CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        b2Vec2 touchLocationInWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO); 
            
        if (swipe != NULL) {
            if (swipe.mouseJoint != NULL) {
                swipe.mouseJoint->SetTarget(touchLocationInWorld);
            }
        }
    }
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) { 
        
        CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
        b2Vec2 touchLocationInWorld = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO); 
        
        if (swipe != NULL) {

            if (swipe.mouseJoint) {[swipe destroyMouseJointInWorld:world];} 
            [swipe destroyBodyInWorld:world];
            [swipe removeFromParentAndCleanup:YES];
            swipe = nil;
        }
    }
}

- (void) dealloc {

	delete world;
	world = NULL;

	
	delete debugDraw;

	[super dealloc];
}
@end
