//
//  objcswitch_tests.m
//  objcswitch_tests
//
//  Created by Nicolas Bouilleaud on 16/01/12.
//  Copyright (c) 2012 Visuamobile. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>
#import "NSObject+NBSwitch.h"


@interface NBSwitchTests : XCTestCase

@end

@implementation NBSwitchTests

- (void)test_respondsToSelectorBasic
{
    XCTAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::)], @"bad!");
    XCTAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::)], @"bad!");
    XCTAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::case::)], @"bad!");
}

- (void)test_respondsToSelectorDefault
{
    XCTAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::default:)], @"bad!");
    XCTAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::default:)], @"bad!");
    XCTAssertTrue([[@"foo" switch] respondsToSelector:@selector(case::case::case::default:)], @"bad!");
}

- (void)test_respondsToSelectorMalformed
{
    XCTAssertFalse([[@"foo" switch] respondsToSelector:@selector(wrong)], @"bad!");
    XCTAssertFalse([[@"foo" switch] respondsToSelector:@selector(case::miss::case::default:)], @"bad!");
}

- (void)testBasicCall_1
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    XCTAssertTrue(success,@"bad!");
}

- (void)testBasicCall_2 // Checks that the implementation is called correctly the second time
{
    [self testBasicCall_1];
}

- (void)testCall_2
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     ];
    XCTAssertTrue(success,@"bad!");
}

- (void)testCallWithDefault_1
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"baz" :^{ success = NO; }
     default:^{ success = YES;}
     ];
    XCTAssertTrue(success,@"bad!");
}

- (void)testCallWithDefault_2
{
    BOOL __block success = NO;
    [[@"foo" switch]
     case:@"bar" :^{ success = NO; }
     case:@"foo" :^{ success = YES; }
     default:^{ success = NO;}
     ];
    XCTAssertTrue(success,@"bad!");
}

@end
