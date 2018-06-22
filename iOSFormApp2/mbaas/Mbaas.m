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

#import "Mbaas.h"
#import "NCMBQuery.h"
#import "Utils.h"

@implementation Mbaas

/***** demo1：保存 *****/
+ (void) saveData:(NSString*)name email:(NSString*)email age:(NSNumber*)age prefecture:(NSString*)prefecture title:(NSString*)title contents:(NSString*)contents errorCallback:(void (^)( NSError *error)) errorCallback {
    
    // 保存先クラスの作成
    NCMBObject *object = [NCMBObject objectWithClassName:@"Inquiry"];
    // データの設定と保存
    [object setObject:name forKey:@"name"];
    [object setObject:email forKey:@"emailAddress"];
    [object setObject:age forKey:@"age"];
    [object setObject:prefecture forKey:@"prefecture"];
    [object setObject:title forKey:@"title"];
    [object setObject:contents forKey:@"contents"];
    [object saveInBackgroundWithBlock:^(NSError *error) {
        //保存失敗
        errorCallback(error);
    }];
}

/***** demo2：全件検索 *****/
+ (void) getAllData: (void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback {
    // インスタンスの生成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Inquiry"];
    // 保存日時降順
    [query orderByDescending:@"createDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // 検索失敗
            errorCallback(error);
        } else {
             // 検索成功
            successCallback(objects);
        }
    }];
}

/***** demo3-1：条件検索 *****/
+ (void) getSearchData:(NSString*)q searchBy:(SearchByEnum)searchBy successCallback:(void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback {
    // インスタンスの生成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Inquiry"];
    // 保存日時降順
    [query orderByDescending:@"createDate"];
    // データの条件検索取得（完全一致）
    if (SearchByEmail == searchBy) {
        [query whereKey:@"emailAddress" equalTo:q];
    } else {
        [query whereKey:@"prefecture" equalTo:q];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //検索失敗時の処理
            errorCallback(error);
        } else {
            //検索成功時の処理
            successCallback(objects);
        }
    }];
}

/***** demo3-2：条件検索（範囲指定） *****/
+ (void) getRangeSearchData:(NSNumber*)ageGreaterThan ageLessThan:(NSNumber*)ageLessThan successCallback:(void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback {
    // インスタンスの生成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Inquiry"];
    // 保存日時降順
    [query orderByDescending:@"createDate"];
    // データのの条件検索取得（範囲指定）
    [query whereKey:@"age" greaterThanOrEqualTo:ageGreaterThan];
    [query whereKey:@"age" lessThan:ageLessThan];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // 検索失敗
            errorCallback(error);
        } else {
            // 検索成功
            successCallback(objects);
        }
    }];
}
@end
