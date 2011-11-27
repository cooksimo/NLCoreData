//
//  NLCoreData.m
//  
//  Created by Jesper Skrufve <jesper@neolo.gy>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//  

#import <CoreData/CoreData.h>
#import "NLCoreData.h"

static NLCoreData* NLCoreDataSingleton_ = nil;

#pragma mark -
@implementation NLCoreData

@synthesize
modelName			= modelName_,
storeCoordinator	= storeCoordinator_,
managedObjectModel	= managedObjectModel_;

#pragma mark - Lifecycle

+ (NLCoreData *)shared
{
	@synchronized(self) {
		
		if (!NLCoreDataSingleton_) NLCoreDataSingleton_ = [[self alloc] init];
		return NLCoreDataSingleton_;
	}
	
	return nil;
}

- (void)usePreSeededFile:(NSString *)filePath
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
#ifdef DEBUG
		[NSException raise:@"Preseed-file does not exist at path" format:@"%@", filePath];
#endif
		return;
	}
	
	NSError* error = nil;
	if (![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:[self storePath] error:&error]) {
#ifdef DEBUG
		[NSException raise:@"Copy preseed-file failed" format:@"%@", [error localizedDescription]];
#endif
	}
}

#pragma mark - Property Accessors

- (NSString *)storePath
{
	return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
			stringByAppendingPathComponent:[modelName_ stringByAppendingString:@".sqlite"]];
}

- (NSURL *)storeURL
{
	NSURL* path = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
														  inDomains:NSUserDomainMask] lastObject];
	
	return [path URLByAppendingPathComponent:[modelName_ stringByAppendingString:@".sqlite"]];
}

- (void)setStoreEncrypted:(BOOL)storeEncrypted
{
	NSString* encryption = storeEncrypted ? NSFileProtectionComplete : NSFileProtectionNone;
	NSDictionary* attributes = [NSDictionary dictionaryWithObject:encryption forKey:NSFileProtectionKey];
	
	NSError* error = nil;
	if (![[NSFileManager defaultManager] setAttributes:attributes
										  ofItemAtPath:[self storePath]
												 error:&error]) {
#ifdef DEBUG		
		[NSException
		 raise:@"Persistent Store Exception"
		 format:@"Error Encrypting Store: %@", [error localizedDescription]];
#endif
	}
}

- (BOOL)storeExists
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self storePath]];
}

- (BOOL)isStoreEncrypted
{
	NSError* error = nil;
	NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self storePath] error:&error];
	if (!attributes) {
#ifdef DEBUG
		[NSException raise:@"Persistent Store Exception"
					format:@"Error Retrieving Store Attributes: %@", [error localizedDescription]];
#endif
		return NO;
	}
	
	return [[attributes objectForKey:NSFileProtectionKey] isEqualToString:NSFileProtectionComplete];
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
	if (storeCoordinator_) return storeCoordinator_;
	
	storeCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSMutableDictionary* options = [NSMutableDictionary dictionary];
	[options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	
	NSError* error = nil;
	if (![storeCoordinator_
		  addPersistentStoreWithType:NSSQLiteStoreType
		  configuration:nil
		  URL:[self storeURL]
		  options:options
		  error:&error]) {
#ifdef DEBUG
		[NSException
		 raise:@"Persistent Store Exception"
		 format:@"Error Creating Store: %@", [error localizedDescription]];
#endif
	}
	
	return storeCoordinator_;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (managedObjectModel_) return managedObjectModel_;
	
	NSURL* url = [[NSBundle mainBundle] URLForResource:modelName_ withExtension:@"momd"];
	managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
	return managedObjectModel_;
}

@end