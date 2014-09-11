//
//  UIActionSheet+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/5/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "UIActionSheet+Blocks.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"com.random-ideas.BUTTONS";
static NSString *RI_DISMISS_BLOCK_ASS_KEY = @"com.random-ideas.DISMISS_BLOCK";
static NSString *RI_PRESENT_BLOCK_ASS_KEY = @"com.random-ideas.PRESENT_BLOCK";

@implementation UIActionSheet (Blocks)

-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(RIButtonItem *)inCancelButtonItem destructiveButtonItem:(RIButtonItem *)inDestructiveItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ...
{
    if((self = [self initWithTitle:inTitle delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [NSMutableArray array];
        
        RIButtonItem *eachItem;
        va_list argumentList;
        if (inOtherButtonItems)
        {
            [buttonsArray addObject: inOtherButtonItems];
            va_start(argumentList, inOtherButtonItems);
            while((eachItem = va_arg(argumentList, RIButtonItem *)))
            {
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for(RIButtonItem *item in buttonsArray)
        {
            [self addButtonWithTitle:item.label];
        }
        
        if(inDestructiveItem)
        {
            [buttonsArray addObject:inDestructiveItem];
            NSInteger destIndex = [self addButtonWithTitle:inDestructiveItem.label];
            [self setDestructiveButtonIndex:destIndex];
        }
        if(inCancelButtonItem)
        {
            [buttonsArray addObject:inCancelButtonItem];
            NSInteger cancelIndex = [self addButtonWithTitle:inCancelButtonItem.label];
            [self setCancelButtonIndex:cancelIndex];
        }
        
        objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, buttonsArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self retain]; // keep yourself around!
    }
    return self;
}

- (NSInteger)addButtonItem:(RIButtonItem *)item
{	
    NSMutableArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);	
	
	NSInteger buttonIndex = [self addButtonWithTitle:item.label];
	[buttonsArray addObject:item];
	
	return buttonIndex;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != -1)
    {
        NSArray *buttonsArray = objc_getAssociatedObject(self, RI_BUTTON_ASS_KEY);
        RIButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if(item.action)
            item.action();
        objc_setAssociatedObject(self, RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UIActionSheetBlock dismissBlock = objc_getAssociatedObject(self, RI_DISMISS_BLOCK_ASS_KEY);
    if (dismissBlock)
    {
        dismissBlock(actionSheet);
    }
    objc_setAssociatedObject(self, RI_DISMISS_BLOCK_ASS_KEY, nil, OBJC_ASSOCIATION_COPY);
    
    // iOS8 Fix: this method gets called more than once on an action sheet's delegate when it is
    // dismissed. Obviously this causes a fatal crash when the action sheet has already been released.
    self.delegate = nil;
    
    [self release]; // and release yourself!
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    UIActionSheetBlock presentBlock = objc_getAssociatedObject(self, RI_PRESENT_BLOCK_ASS_KEY);
    if (presentBlock)
    {
        presentBlock(actionSheet);
    }
    objc_setAssociatedObject(self, RI_PRESENT_BLOCK_ASS_KEY, nil, OBJC_ASSOCIATION_COPY);
}

- (void)setDismissBlock:(UIActionSheetBlock)block
{
    NSAssert(block, @"Missing block");
    objc_setAssociatedObject(self, RI_DISMISS_BLOCK_ASS_KEY, block, OBJC_ASSOCIATION_COPY);
}

- (void)setPresentBlock:(UIActionSheetBlock)block
{
    NSAssert(block, @"Missing block");
    objc_setAssociatedObject(self, RI_PRESENT_BLOCK_ASS_KEY, block, OBJC_ASSOCIATION_COPY);
}

@end
