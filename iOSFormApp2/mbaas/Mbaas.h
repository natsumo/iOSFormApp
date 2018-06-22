/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "NCMBObject.h"

typedef NS_ENUM(NSUInteger, SearchByEnum) {
    SearchByEmail = 100,
    SearchByPrefecture = 200,
};

@interface Mbaas : NSObject
+ (void) saveData:(NSString*)name email:(NSString*)email age:(NSNumber*)age prefecture:(NSString*)prefecture title:(NSString*)title contents:(NSString*)contents errorCallback:(void (^)( NSError *error)) errorCallback;
+ (void) getAllData: (void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback;
+ (void) getSearchData:(NSString*)q searchBy:(SearchByEnum)searchBy successCallback:(void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback;
+ (void) getRangeSearchData:(NSNumber*)ageGreaterThan ageLessThan:(NSNumber*)ageLessThan successCallback:(void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback;
@end
