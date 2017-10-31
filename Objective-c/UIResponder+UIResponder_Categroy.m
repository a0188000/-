//
//  UIResponder+UIResponder_Categroy.m
//  keyboardHandle - Objc
//
//  Created by EVERTRUST on 2017/10/31.
//  Copyright © 2017年 EVERTRUST. All rights reserved.
//

#import "UIResponder+UIResponder_Categroy.h"

@implementation UIResponder (UIResponder_Categroy)

static UIResponder* _currentFirstResponder;

+(UIResponder *)firstResponder {
    _currentFirstResponder = nil;
    [UIApplication.sharedApplication sendAction:@selector(findFristResponder:) to:nil from:nil forEvent:nil];
    return _currentFirstResponder;
}

-(void) findFristResponder: (id)sender {
    _currentFirstResponder = self;
}

@end
