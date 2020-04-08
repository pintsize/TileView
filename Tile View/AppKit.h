//
//  AppKit.swift
//  Tile View
//
//  Created by Jacob Hazelgrove on 4/5/20.
//  Copyright © 2020 Jacob Hazelgrove. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AppKit <NSObject>

- (void)showColorPanel;

- (void)hideCursor;
- (void)showCursor;

@end
