//
//  TextAlertView.h
//  Fast Text
//
//  Created by Casey Liss on 20/04/2010.
//  Copyright 2010 Casey Liss. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUITextFieldHeight 30.0
#define kUITextFieldXPadding 12.0
#define kUITextFieldYPadding 10.0
#define kUIAlertOffset 100.0

@interface TextAlertView : UIAlertView 
{
	UITextField *textField;
	BOOL layoutDone;
}

@property (nonatomic, readonly) UITextField *textField;

- (id)initWithTitle:(NSString *)title 
			message:(NSString *)message 
		   delegate:(id<UIAlertViewDelegate>)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end