//
//  NSFetchRequest+NLCoreData.h
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

@interface NSFetchRequest (NLCoreData)

/**
 @name Initialization
 A fetch request set to be executed in the shared context for the current thread.
 @param entity The NSManagedObject subclass of the entity.
 @return The NSFetchRequest.
 */
+ (NSFetchRequest *)fetchRequestWithEntity:(Class)entity;

/**
 @name Initialization
 A fetch request.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context in which to execute the fetch request.
 @return The NSFetchRequest.
 */
+ (NSFetchRequest *)fetchRequestWithEntity:(Class)entity context:(NSManagedObjectContext *)context;

/**
 @name Sorting
 Adds add a sort descriptor the fetch request. First added is primary, second added is secondary, etc.
 @param key The keypath to use when performing a comparison.
 @param ascending YES if the receiver specifies sorting in ascending order, otherwise NO.
 */
- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending;

@end
