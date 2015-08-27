//
//  SimpleObjectStore.h
//  Offline Surveys
//
//  Created by James Snee on 7/20/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

/*
 * A super simple in-memory object store.
 * Just stores a list of OSUserResponses and can dump them to various types of files or over the network
 */

#import <Foundation/Foundation.h>

#import "OSUserResponse.h"

@interface SimpleObjectStore : NSObject

@property (strong, nonatomic) NSString *currentOutputFileURL;

+ (SimpleObjectStore *) getObjectStore;

- (void) storeObject:(OSUserResponse *)response;
- (void) outputStoreWithBlock:(void (^)(OSUserResponse *))outputBlock;
- (void) flushToDisk;
- (NSString *) getFileContents;
- (void) clearAll;

@end
