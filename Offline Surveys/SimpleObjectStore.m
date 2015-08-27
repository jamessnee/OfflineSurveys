//
//  SimpleObjectStore.m
//  Offline Surveys
//
//  Created by James Snee on 7/20/15.
//  Copyright (c) 2015 James Snee. All rights reserved.
//

#import "SimpleObjectStore.h"

SimpleObjectStore *simpleObjectStore;

@implementation SimpleObjectStore {
    NSMutableArray *_objectStore;
}

+ (SimpleObjectStore *) getObjectStore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simpleObjectStore = [SimpleObjectStore new];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"currentsurvey.csv"];
        simpleObjectStore.currentOutputFileURL = path;
    });
    return simpleObjectStore;
}

- (instancetype) init {
    if ((self = [super init])) {
        _objectStore = [NSMutableArray new];
    }
    return self;
}

- (void) storeObject:(OSUserResponse *)response {
    [_objectStore addObject:response];
}

- (void) outputStoreWithBlock:(void (^)(OSUserResponse *))outputBlock {
    for (id tempResp in _objectStore) {
        if ([tempResp isKindOfClass:[OSUserResponse class]]) {
            OSUserResponse *response = (OSUserResponse *)tempResp;
            outputBlock(response);
        }
    }
}

- (void) initFile {
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:self.currentOutputFileURL];
    if (!file) {
        if (![[NSFileManager defaultManager] createFileAtPath:self.currentOutputFileURL contents:nil attributes:nil]) {
            NSLog(@"Failed to create survey file");
        } else {
            file = [NSFileHandle fileHandleForWritingAtPath:self.currentOutputFileURL];
            NSString *initialData = @"FirstName,Surname,Salutation,Email,Question1,Question2\n";
            [file writeData:[initialData dataUsingEncoding:NSUTF8StringEncoding]];
            file = [NSFileHandle fileHandleForReadingAtPath:self.currentOutputFileURL];
        }
    }
}

- (void) flushToDisk {
    // Check whether the file exists
    [self initFile];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:self.currentOutputFileURL];

    // Read the current contents of the file
    NSData *fileData = [file readDataToEndOfFile];
    NSMutableString *currContents = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];

    // Append the new data
    for (OSUserResponse *response in _objectStore) {
        [currContents appendFormat:@"%@,%@,%@,%@,%@,%@\n",
         response.first_name,response.surname, response.salutation,
         response.emailAddress, response.q1Answer, response.q2Answer];
    }

    // Write out to the file
    file = [NSFileHandle fileHandleForWritingAtPath:self.currentOutputFileURL];
    [file writeData:[currContents dataUsingEncoding:NSUTF8StringEncoding]];

    [_objectStore removeAllObjects];

//    // Debug
//    file = [NSFileHandle fileHandleForReadingAtPath:self.currentOutputFileURL];
//    NSString *debug = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    NSLog(@"READBACK:%@", debug);
}

- (NSString *)getFileContents {
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:self.currentOutputFileURL];
    NSString *contents = [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    return contents;
}

- (void)clearAll {
    [_objectStore removeAllObjects];
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:self.currentOutputFileURL]) {
        NSError *error = nil;
        if ([[NSFileManager defaultManager] removeItemAtPath:self.currentOutputFileURL error:&error]) {
            // Create the file again
            [self initFile];
        } else {
            NSLog(@"Error removing file: %@", error);
        }
    }

}

@end
