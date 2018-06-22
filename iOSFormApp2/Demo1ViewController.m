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

#import "Demo1ViewController.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "SWRevealViewController.h"
#import "NCMBObject.h"
#import "Utils.h"
#import "Mbaas.h"
#import "ProgressHUD.h"

@interface Demo1ViewController ()
{
    NSMutableArray *_pickerAgeData;
    NSMutableArray *_pickerPreData;
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerAge;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPre;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtContents;

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"demo1：保存";
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    // setup UITextView _txtContents
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    _txtContents.layer.borderColor = borderColor.CGColor;
    _txtContents.layer.borderWidth = 1.0;
    _txtContents.layer.cornerRadius = 3.0;
    _txtContents.placeholder = @"contents";
    
    // Initialize Data
    _pickerAgeData = [NSMutableArray new];
    [_pickerAgeData addObject:@"- age -"];
    for (int i = 0; i <= 120; ++i) {
        [_pickerAgeData addObject:[NSString stringWithFormat:@"%i",i]];
    }
    _pickerPreData = [NSMutableArray arrayWithArray:@[@"- prefecture -", @"北海道",@"青森県",@"岩手県",@"宮城県",@"秋田県",@"山形県",@"福島県",@"茨城県",@"栃木県",@"群馬県",@"埼玉県",@"千葉県",@"東京都",@"神奈川県",@"新潟県",@"富山県",@"石川県",@"福井県",@"山梨県",@"長野県",@"岐阜県",@"静岡県",@"愛知県",@"三重県",@"滋賀県",@"京都府",@"大阪府",@"兵庫県",@"奈良県",@"和歌山県",@"鳥取県",@"島根県",@"岡山県",@"広島県",@"山口県",@"徳島県",@"香川県",@"愛媛県",@"高知県",@"福岡県",@"佐賀県",@"長崎県",@"熊本県",@"大分県",@"宮崎県",@"鹿児島県",@"沖縄県"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma action
- (IBAction)btnSaveClick:(id)sender {
    // 入力チェック
    if ([@"" isEqualToString:_txtName.text]) {
        [Utils showAlert:self title:@"Alert" message: NSLocalizedString(@"Name is not entered", nil)];
    } else if ([@"" isEqualToString:_txtEmail.text]) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"E-mail address is not entered", nil)];
    } else if ([_pickerAge selectedRowInComponent:0] == 0) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Age has not been entered", nil)];
    } else if ([_pickerPre selectedRowInComponent:0] == 0) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"State or province is not entered", nil)];
    } else if ([@"" isEqualToString:_txtTitle.text]) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Inquiry title has not been entered", nil)];
    } else if ([@"" isEqualToString:_txtContents.text]) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Inquiry content is not entered", nil)];

        // データの保存
    } else {
        [ProgressHUD show:@"Please wait..."];
        NSString *name = _txtName.text;
        NSString *email = _txtEmail.text;
        NSString *pre = [NSString stringWithFormat:@"%@", [_pickerPreData objectAtIndex:[_pickerPre selectedRowInComponent:0]]];
        NSNumber *age = [NSNumber numberWithInteger:[_pickerAge selectedRowInComponent:0] - 1];
        NSString *title = _txtTitle.text;
        NSString *contents = _txtContents.text;
        [Mbaas saveData:name email:email age:age prefecture:pre title:title contents:contents errorCallback:^(NSError *error) {
            [ProgressHUD dismiss];
            if (error) {
                //保存失敗
                [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"I failed to accept inquiries", nil)];
            } else {
                // 保存成功
                [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Inquiries accepted", nil)];
            }
        }];
    }
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.pickerAge) {
        return _pickerAgeData.count;
    }
    else {
        return _pickerPreData.count;
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.pickerAge) {
        return [_pickerAgeData objectAtIndex:row];
    } else {
        return [_pickerPreData objectAtIndex:row];
    }
}

@end
