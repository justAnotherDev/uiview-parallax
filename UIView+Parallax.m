//
//  UIView+Parallax.m
//

#import "UIView+Parallax.h"
#import <objc/runtime.h>

static const void* ParallaxOffsetMotionEffect = &ParallaxOffsetMotionEffect;

@implementation UIView (Parallax)

-(void)setParallaxOffset:(int)parallaxOffset {
	if (self.parallaxOffset == parallaxOffset) {
		return;
	}
	
	// remove existing parallax effects
	UIMotionEffectGroup *motionEffect = objc_getAssociatedObject(self, ParallaxOffsetMotionEffect);
	if (motionEffect) {
		[self removeMotionEffect:motionEffect];
		objc_setAssociatedObject(self, ParallaxOffsetMotionEffect, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	// no need to add an effect group for 0
	if (parallaxOffset == 0) {
		return;
	}
	
	// setup vertical effect
	UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffect.minimumRelativeValue = @(-parallaxOffset);
	verticalMotionEffect.maximumRelativeValue = @(parallaxOffset);
	
	UIInterpolatingMotionEffect *verticalMotionEffect2 = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"transform.rotation.x" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	verticalMotionEffect2.minimumRelativeValue = @(-M_PI/8.);
	verticalMotionEffect2.maximumRelativeValue = @(M_PI/8.);
	
	// setup horizontal effect
	UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontalMotionEffect.minimumRelativeValue = @(-parallaxOffset);
	horizontalMotionEffect.maximumRelativeValue = @(parallaxOffset);
	
	UIInterpolatingMotionEffect *horizontalMotionEffect2 = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"transform.rotation.y" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
	horizontalMotionEffect2.minimumRelativeValue = @(-M_PI/8.);
	horizontalMotionEffect2.maximumRelativeValue = @(M_PI/8.);
	
	// link the two effects and add them to self
	UIMotionEffectGroup *motionGroup = [[UIMotionEffectGroup alloc] init];
	motionGroup.motionEffects = @[horizontalMotionEffect, horizontalMotionEffect2, verticalMotionEffect, verticalMotionEffect2];
	[self addMotionEffect:motionGroup];
	
	// store the effect group for later removal
	objc_setAssociatedObject(self, ParallaxOffsetMotionEffect, motionGroup, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(int)parallaxOffset {
	UIMotionEffectGroup *motionEffect = objc_getAssociatedObject(self, ParallaxOffsetMotionEffect);
	return [[[[motionEffect motionEffects] firstObject] maximumRelativeValue] intValue];
}

@end
