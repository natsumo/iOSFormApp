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

#import "Demo3ViewController.h"
#import "SearchResultTableViewCell.h"
#import "SWRevealViewController.h"
#import "Utils.h"
#import "Mbaas.h"
#import "ProgressHUD.h"

@interface Demo3ViewController (){
    NSMutableArray *_pickerPreData;
    NSArray *arrTbvData;
}
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblResultCount;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerPre;

@end

@implementation Demo3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"demo3-1：条件検索";
    arrTbvData = [NSArray array];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    _pickerPreData = [NSMutableArray arrayWithArray:@[@"- prefecture -", @"北海道",@"青森県",@"岩手県",@"宮城県",@"秋田県",@"山形県",@"福島県",@"茨城県",@"栃木県",@"群馬県",@"埼玉県",@"千葉県",@"東京都",@"神奈川県",@"新潟県",@"富山県",@"石川県",@"福井県",@"山梨県",@"長野県",@"岐阜県",@"静岡県",@"愛知県",@"三重県",@"滋賀県",@"京都府",@"大阪府",@"兵庫県",@"奈良県",@"和歌山県",@"鳥取県",@"島根県",@"岡山県",@"広島県",@"山口県",@"徳島県",@"香川県",@"愛媛県",@"高知県",@"福岡県",@"佐賀県",@"長崎県",@"熊本県",@"大分県",@"宮崎県",@"鹿児島県",@"沖縄県"]];
}

#pragma action
- (IBAction)btnSearchByEmail:(id)sender {
    if ([@"" isEqualToString:_txtEmail.text]) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"please fill in the value", nil)];
    } else {
        [ProgressHUD show:@"Loading..."];
        [Mbaas getSearchData:_txtEmail.text searchBy:SearchByEmail successCallback:^(NSArray *objects) {
            //検索成功時の処理
            arrTbvData = objects;
            self.lblResultCount.text = [NSString stringWithFormat:NSLocalizedString(@"Condition Search Result", nil), (unsigned long)arrTbvData.count];
            [self.table reloadData];
            _viewResultCount.hidden = NO;
            [ProgressHUD dismiss];
        } errorCallback:^(NSError *error) {
            //検索失敗時の処理
            [ProgressHUD dismiss];
            [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Data acquisition failed", nil)];
        }];
    }
}
- (IBAction)btnSearchByPre:(id)sender {
    if ([_pickerPre selectedRowInComponent:0] == 0) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"please fill in the value", nil)];
    } else {
        [ProgressHUD show:@"Loading..."];
        NSString *prefecture = [_pickerPreData objectAtIndex:[_pickerPre selectedRowInComponent:0]];
        [Mbaas getSearchData:prefecture searchBy:SearchByPrefecture successCallback:^(NSArray *objects) {
            //検索成功時の処理
            arrTbvData = objects;
            self.lblResultCount.text = [NSString stringWithFormat:NSLocalizedString(@"Condition Search Result", nil), (unsigned long)arrTbvData.count];
            [self.table reloadData];
            _viewResultCount.hidden = NO;
            [ProgressHUD dismiss];
        } errorCallback:^(NSError *error) {
            //検索失敗時の処理
            [ProgressHUD dismiss];
            [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Data acquisition failed", nil)];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma pickerview ui

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerPreData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickerPreData objectAtIndex:row];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrTbvData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"Demo31TableViewCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (nil == cell) {
        [tableView registerClass:[SearchResultTableViewCell self] forCellReuseIdentifier:cellId];
        cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (arrTbvData.count > 0) {
        cell.lblTitle.text = [[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.lblCreatedDate.text = [Utils formatDate:[[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"createDate"]];
        NSString *contents = [NSString stringWithFormat:@"%@ (%@) - %@ - %@",
                              [[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"name"],
                              [[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"prefecture"],
                              [[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"age"],
                              [[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"emailAddress"]];
        cell.lblContents.text = contents;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Utils showAlert:self title:@"Alert" message:[[arrTbvData objectAtIndex:indexPath.row] objectForKey:@"contents"]];
}

@end
