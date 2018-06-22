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

#import "Demo32ViewController.h"
#import "SWRevealViewController.h"
#import "SearchResultTableViewCell.h"
#import "Utils.h"
#import "Mbaas.h"
#import "ProgressHUD.h"

@interface Demo32ViewController (){
    NSMutableArray *arrPickerData;
    NSArray *arrTbvData;
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *pickerGreaterThan;
@property (weak, nonatomic) IBOutlet UILabel *lblResultCount;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerLessThan;

@end

@implementation Demo32ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"demo3-2：条件検索";
    arrTbvData = [NSArray array];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    arrPickerData = [NSMutableArray new];
    [arrPickerData addObject:@"- age -"];
    for (int i = 0; i <= 120; ++i) {
        [arrPickerData addObject:[NSString stringWithFormat:@"%i",i]];
    }
}
- (IBAction)btnSearchAge:(id)sender {
    NSInteger greater = [_pickerGreaterThan selectedRowInComponent:0] - 1;
    NSInteger less = [_pickerLessThan selectedRowInComponent:0] -1;
    if (greater == -1 || less == -1) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"please fill in the value", nil)];
    } else if (greater >= less) {
        [Utils showAlert:self title:@"Alert" message:NSLocalizedString(@"Value is invalid", nil)];
    } else {
        [ProgressHUD show:@"Loading..."];
        [Mbaas getRangeSearchData:[NSNumber numberWithInteger:greater] ageLessThan:[NSNumber numberWithInteger:less] successCallback:^(NSArray *objects) {
            //検索成功時の処理
            arrTbvData = objects;
            self.lblResultCount.text = [NSString stringWithFormat:NSLocalizedString(@"Conditional search (range designation) result", nil), (unsigned long)arrTbvData.count];
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
    return arrPickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrPickerData objectAtIndex:row];
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
    NSString *cellId = @"Demo32TableViewCell";
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
