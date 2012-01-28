//
//  TextAlertView.m
//  Fast Text
//
//  Created by Casey Liss on 20/04/2010.
//  Copyright 2010 Casey Liss. All rights reserved.
//

#import "TextAlertView.h"
#import "FastTextAppDelegate.h"

@implementation TextAlertView

//@synthesize textField;
- (UITextField *)textField
{
    if ([FastTextAppDelegate getSystemVersionAsAnInteger] < __IPHONE_5_0)
    {
        return textField;
    }
    else
    {
        return [self textFieldAtIndex:0];
    }
}

/*
 *	Initialize view with maximum of two buttons
 */
- (id)initWithTitle:(NSString *)title 
			message:(NSString *)message 
		   delegate:(id)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ... 
{
	self = [super initWithTitle:title 
						message:message 
					   delegate:delegate 
			  cancelButtonTitle:cancelButtonTitle
			  otherButtonTitles:otherButtonTitles, nil];
	
	if (self) 
	{
        NSLog(@"Current version: %i, iOS 5: %i", [FastTextAppDelegate getSystemVersionAsAnInteger], __IPHONE_5_0);
        if ([FastTextAppDelegate getSystemVersionAsAnInteger] < __IPHONE_5_0)
        {
            // Create and add UITextField to UIAlertView
            textField = [[UITextField alloc] initWithFrame:CGRectZero];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAlpha:0.75];
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            [textField setDelegate:delegate];
            // insert UITextField before first button
            BOOL inserted = NO;
            for (UIView *view in self.subviews)
            {
                if (!inserted && ![view isKindOfClass:[UILabel class]])
                {
                    [self insertSubview:textField aboveSubview:view];
                }
            }
            
            //[self addSubview:myTextField];
            // ensure that layout for views is done once
            layoutDone = NO;
        }
        else
        {
            [self setAlertViewStyle:UIAlertViewStylePlainTextInput];
        }
	}
	return self;
}

/*
 *	Show alert view and make keyboard visible
 */
- (void) show {
	[super show];
	[[self textField] becomeFirstResponder];
}

/*
 *	Determine maximum y-coordinate of UILabel objects. This method assumes that only
 *	following objects are contained in subview list:
 *	- UILabel
 *	- UITextField
 *	- UIThreePartButton (Private Class)
 */
- (CGFloat) maxLabelYCoordinate 
{
	// Determine maximum y-coordinate of labels
	CGFloat maxY = 0;
	for (UIView *view in self.subviews) 
	{
		if ([view isKindOfClass:[UILabel class]]) 
		{
			CGRect viewFrame = [view frame];
			CGFloat lowerY = viewFrame.origin.y + viewFrame.size.height;
			if (lowerY > maxY)
			{
				maxY = lowerY;
			}
		}
	}
	return maxY;
}

/*
 *	Override layoutSubviews to correctly handle the UITextField
 */
- (void)layoutSubviews 
{
    if ([FastTextAppDelegate getSystemVersionAsAnInteger] < __IPHONE_5_0)
    {
        [super layoutSubviews];
        CGRect frame = [self frame];
        CGFloat alertWidth = frame.size.width;
        
        // Perform layout of subviews just once
        if (!layoutDone) 
        {
            CGFloat labelMaxY = [self maxLabelYCoordinate];
            
            // Insert UITextField below labels and move other fields down accordingly
            for (UIView *view in self.subviews)
            {
                if ([view isKindOfClass:[UITextField class]])
                {
                    CGRect viewFrame = CGRectMake(kUITextFieldXPadding, 
                                                  labelMaxY + kUITextFieldYPadding, 
                                                  alertWidth - 4.0*kUITextFieldXPadding, 
                                                  kUITextFieldHeight);
                    [view setFrame:viewFrame];
                }
                else if (![view isKindOfClass:[UILabel class]]) 
                {
                    CGRect viewFrame = [view frame];
                    viewFrame.origin.y += kUITextFieldHeight;
                    [view setFrame:viewFrame];
                }
            }
            
            // size UIAlertView frame by height of UITextField
            frame.size.height += kUITextFieldHeight + 2.0;
            [self setFrame:frame];
            layoutDone = YES;
        }
        else
        {
            // reduce the x placement and width of the UITextField based on UIAlertView width
            for (UIView *view in self.subviews)
            {
                if ([view isKindOfClass:[UITextField class]])
                {
                    CGRect viewFrame = [view frame];
                    viewFrame.origin.x = kUITextFieldXPadding;
                    viewFrame.size.width = alertWidth - 2.0*kUITextFieldXPadding;
                    [view setFrame:viewFrame];
                }
            }
        }
    }
}

- (void)didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	if ([FastTextAppDelegate getSystemVersionAsAnInteger] >= __IPHONE_4_2 &&
        [FastTextAppDelegate getSystemVersionAsAnInteger] < __IPHONE_5_0)
	{
		if ([subview isMemberOfClass:[UIImageView class]])
		{
			[subview setTransform:CGAffineTransformMakeTranslation(0.0, -kUITextFieldHeight)];
		}
	}
}


@end