//
//  Tag.h
//  Simplenote
//
//  Created by Michael Johnston on 10-04-19.
//  Copyright 2010 Simperium. All rights reserved.
//

@import Simperium;

@interface Tag : SPManagedObject {
	NSString *name;
	NSMutableArray *recipients;
	int count;
	NSNumber *index;
    NSString *share;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *recipients;
@property (nonatomic) int count;
@property (nonatomic, retain) NSNumber *index;
@property (nonatomic, retain) NSString *share;

- (void)addRecipient:(NSString *)emailAddress;

@end
