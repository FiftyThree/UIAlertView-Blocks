//
//  UIActionSheet+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

typedef void (^UIActionSheetBlock)(UIActionSheet *actionSheet);

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(RIButtonItem *)inCancelButtonItem destructiveButtonItem:(RIButtonItem *)inDestructiveItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(RIButtonItem *)item;

- (void)setDismissBlock:(UIActionSheetBlock)block;
- (void)setPresentBlock:(UIActionSheetBlock)block;

@end
