//
//  RIButtonItem.m
//  Shibui
//
//  Created by Jiva DeVoe on 1/12/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "RIButtonItem.h"

@implementation RIButtonItem
@synthesize label;
@synthesize action;

+(id)item
{
    return [[self new] autorelease];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    id newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}

-(void)dealloc
{
    [action release];
    action = nil;
    [label release];
    label = nil;
    [super dealloc];
}

@end

