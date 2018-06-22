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

#import "Utils.h"

@implementation Utils
+ (NSString*) formatDate: (NSString*)strDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}

+ (void) showAlert:(UIViewController*)vc title:(NSString*)title message:(NSString*) msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
    [alert addAction:ok];
    [vc presentViewController:alert animated:YES completion:nil];
}
@end
