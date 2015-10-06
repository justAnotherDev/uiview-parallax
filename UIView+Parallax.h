//
//  UIView+Parallax.h
//

#import <UIKit/UIKit.h>

@interface UIView (Parallax)

/*!
 @brief The number of pixels the view is allowed to shift in each direction when interacted with.
 @note Defaults to 0.
 */
@property (nonatomic, assign) int parallaxOffset;

@end
