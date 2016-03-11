//
//  AddressView.m
//  AiJia_2014
//
//  Created by 宝源科技 on 15-2-12.
//  Copyright (c) 2015年 lipengjun. All rights reserved.
//

#import "AddressScrollView.h"
#import "AddressViewController.h"
#import "NetWorking.h"
#import "SharedHandle.h"
#import "ClearViewController.h"
static NSString *const getAreaId = @"getAreaId";
static NSString *const getStreetId = @"getStreetId";
static NSString *const newAddress = @"newAddress";
static NSString *const changeAddress = @"changeAddress";
@interface AddressScrollView ()
{
    UITextField *_nameTextField;
    UITextField *_mobilTextField;
    UIButton    *_areaButton;
    UIButton    *_streetButton;
    UITextField *_addressTextField;
    UITextField *_postTextField;
    AddressViewController *addressViewController;
    NSString    *areaId;
    NSString    *areaPath;
    NSInteger    _Level1;
    NSInteger    _Level2;
    NSMutableArray *_areaPathArray;
    NSString    *_areaNumber;
    NSString    *_streetNumber;
    BOOL         _select;
}
@end

@implementation AddressScrollView
- (id)initWithFrame:(CGRect)frame target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        _areaPathArray = [NSMutableArray array];
        addressViewController = target;
        UIView *nameView = [self viewWithFrame:CGRectMake(15, 10, kScreenBounds.size.width, 70) title:@"姓名:"];
        _nameTextField = [nameView subviews][1];
            //_nameTextField.text = @"123";
        [self addSubview:nameView];
        
        UIView *mobelView = [self viewWithFrame:CGRectMake(nameView.frame.origin.x, kSetFrameY(nameView), nameView.bounds.size.width, nameView.bounds.size.height) title:@"手机:"];
        _mobilTextField = [mobelView subviews][1];
        _mobilTextField.keyboardType = UIKeyboardTypePhonePad;
        [self addSubview:mobelView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(mobelView.frame.origin.x, kSetFrameY(mobelView), 70, 20)];
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = @"所在地区:";
        [self addSubview:label];
        
        UIView *areaView = [self viewWithButtonFrame:CGRectMake(kSetFrameX(label) + 10, label.frame.origin.y, 100, 35) action:@selector(getTheInformationOfStreet:) title:@"地区"];
        areaView.backgroundColor = [UIColor whiteColor];
        _areaButton = [areaView subviews][0];
        [self addSubview:areaView];
        
        UIView *streetView = [self viewWithButtonFrame:CGRectMake(kSetFrameX(areaView) + 10, areaView.frame.origin.y, areaView.bounds.size.width, areaView.bounds.size.height) action:@selector(getTheInformationOfStreet:) title:@"街道"];
        streetView.backgroundColor = [UIColor whiteColor];
        _streetButton = [streetView subviews][0];
        [self addSubview:streetView];
        
        UIView *addressView = [self viewWithFrame:CGRectMake(label.frame.origin.x, kSetFrameY(streetView), mobelView.bounds.size.width, mobelView.bounds.size.height) title:@"地址:"];
        _addressTextField = [addressView subviews][1];
        [self addSubview:addressView];
        
        UIView *postView = [self viewWithFrame:CGRectMake(addressView.frame.origin.x, kSetFrameY(addressView), addressView.bounds.size.width, addressView.bounds.size.height) title:@"邮编:"];
        _postTextField = [postView subviews][1];
        _postTextField.keyboardType = UIKeyboardTypePhonePad;
        [self addSubview:postView];
        
        UIButton *endButton = [[UIButton alloc] initWithFrame:CGRectMake(postView.frame.origin.x, kSetFrameY(postView), kScreenBounds.size.width - 30, 35)];
        [endButton setTitle:@"确定" forState:UIControlStateNormal];
        [endButton setBackgroundColor:[UIColor redColor]];
        [self addSubview:endButton];
    }
    return self;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *view = [tableView superview];
    view.hidden = YES;
    if (_select) {
            //NSLog(@"%@", _areaPathArray);
         areaId = [_areaPathArray[indexPath.row] objectForKey:@"aId"];
            //areaId = [[[dic objectForKey:@"areas"] firstObject] objectForKey:@"aId"];
         _areaNumber = [_areaPathArray[indexPath.row] objectForKey:@"aId"];
            //_areaNumber = [[[dic objectForKey:@"areas"] firstObject] objectForKey:@"aId"] ;
        [_areaButton setTitle:[_areaPathArray[indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
            //[_areaButton setTitle:[[[dic objectForKey:@"areas"] firstObject] objectForKey:@"name"] forState:UIControlStateNormal];
            //        [_areaPathArray removeAllObjects];
            //        [_areaPathArray addObjectsFromArray:[dic objectForKey:@"areas"]];
            //        [_tableView reloadData];
    }else{
         [_streetButton setTitle:[_areaPathArray[indexPath.row] objectForKey:@"name"] forState:UIControlStateNormal];
         _streetNumber = [_areaPathArray[indexPath.row] objectForKey:@"aId"];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _areaPathArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier];
    }
    cell.textLabel.text = [_areaPathArray[indexPath.row] objectForKey:@"name"];
    return cell;
}
    //aim
- (void)theChangeOfAddress:(NSString *)aim
{
        //NSLog(@"=======新建地址");
    if ([aim isEqualToString:@"新建地址"]) {
        if (![_nameTextField.text isEqualToString:@""] && ![_mobilTextField.text isEqualToString:@""] && ![_areaButton.titleLabel.text isEqualToString:@""] && ![_streetButton.titleLabel.text isEqualToString:@""] && ![_addressTextField.text isEqualToString:@""] && ![_postTextField.text isEqualToString:@""]) {
            NSString *name = [_nameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *address = [_addressTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.receiver.add&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@&name=%@&areaId=%@&areaPath=%@&address=%@&zipCode=%@&mobile=%@&isDefault=0", kGetData(@"memberId"), name, _areaNumber, _streetNumber, address,_postTextField.text, _mobilTextField.text];
            [self address:strUrl];
        }else{
            [SharedHandle sharedPromptBox:@"请您完善信息"];
        }
    }else if ([aim isEqualToString:@"修改地址"]){
        NSString *name = [_nameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *address = [_addressTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.product.receiver.mod&v=1.0&format=json&locale=zh_CN&client=iPhone&memberId=%@&receiverId=%@&name=%@&areaId=%@&areaPath=%@&address=%@&zipCode=%@&mobile=%@&isDefault=0", kGetData(@"memberId"), [_addressDic objectForKey:@"rId"],name, _areaNumber, _streetNumber, address,_postTextField.text, _mobilTextField.text];
        [self address:strUrl];
    }
}
- (void)address:(NSString *)url
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressEnd:) name:newAddress object:nil];
    [NetWorking netWorkingWithUrl:url identification:newAddress];
}
- (void)addressEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:newAddress object:nil];
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil]);
    if ([[sender object] isKindOfClass:[NSString class]]) {
        [SharedHandle sharedPromptBox:[sender object]];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            [[[UIAlertView alloc] initWithTitle:@"成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }
}
#pragma mark UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        //NSLog(@"%@", addressViewController.navigationController.viewControllers);
    ClearViewController *viewController = addressViewController.navigationController.viewControllers[3];
    // [viewController getTheDefaultShippingAddress];
    [addressViewController.navigationController popToViewController:viewController animated:YES];
    
  [viewController getTheDefaultShippingAddress];
}
#pragma mark Get the information of street
- (void)getTheInformationOfStreet:(UIButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"地区"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheInformationOfStreetEnd:) name:getAreaId object:nil];
        NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.area.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&areaId=0"];
        [NetWorking netWorkingWithUrl:strUrl identification:getAreaId];
        _Level1 = 0;
    }else if ([btn.titleLabel.text isEqualToString:@"街道"]){
        [self returnBackKeyboard];
        if (areaId == nil) {
            [SharedHandle sharedPromptBox:@"请您先选择地区"];
        }else{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTheInformationOfStreetEnd:) name:getStreetId object:nil];
            NSString *strUrl = [NSString stringWithFormat:@"appKey=00001&method=wop.area.list.get&v=1.0&format=json&locale=zh_CN&client=iPhone&areaId=%@", areaId];
            [NetWorking netWorkingWithUrl:strUrl identification:getStreetId];
            _Level1 = 1;
        }
    }
}
- (void)getTheInformationOfStreetEnd:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getAreaId object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:getStreetId object:nil];
    UIView *view = [_tableView superview];
    view.hidden = NO;
    if (_Level1 == 0) {
        //获取地区信息
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
            //NSLog(@"%@", dic);
            //NSLog(@"dic = %@", [[[dic objectForKey:@"areas"] firstObject] objectForKey:@"name"]);
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _select = YES;
            [_areaPathArray removeAllObjects];
            [_areaPathArray addObjectsFromArray:[dic objectForKey:@"areas"]];
            [_tableView reloadData];
        }
    }else if(_Level1 == 1){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[sender object] options:0 error:nil];
        NSInteger resultCode = [[dic objectForKey:@"resultCode"] integerValue];
        if (resultCode == 0) {
            _select = NO;
            [_areaPathArray removeAllObjects];
                //NSLog(@"dic === %@", dic);
                //[_areaPathArray arrayByAddingObjectsFromArray:[dic objectForKey:@"areas"] ];
            [_areaPathArray addObjectsFromArray:[dic objectForKey:@"areas"]];
            [_tableView reloadData];
        }
    }
}
#pragma mark - Creating controls
- (UIImageView *)viewWithButtonFrame:(CGRect)frame action:(SEL)action title:(NSString *)title
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    view.image = [UIImage imageNamed:@"xiugaidizhi.png"];
    view.userInteractionEnabled = YES;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(5, 0, 60, 35);
    button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //button1.backgroundColor = [UIColor yellowColor];
    button1.titleLabel.textColor = [UIColor blackColor];
    button1.titleLabel.textColor = [UIColor blackColor];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(kSetFrameX(button1), button1.frame.origin.y, 35, 35);
        //button2.backgroundColor = [UIColor redColor];
    [button2 setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button2 setTitle:title forState:UIControlStateNormal];
    [button2 addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    return view;
}

- (UIView *)viewWithFrame:(CGRect)frame title:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    label.font = [UIFont systemFontOfSize:16.0];
    label.text = title;
    [view addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(label.frame.origin.x, kSetFrameY(label) + 5, kScreenBounds.size.width - 30, 35)];
    textField.clearButtonMode =UITextFieldViewModeAlways;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14.0];
    [textField setDelegate:(id<UITextFieldDelegate>)self];
    [view addSubview:textField];
    return view;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    if (textField == _mobilTextField) {
        self.contentOffset = CGPointMake(0, 16);
    }else if (textField == _addressTextField || textField == _postTextField){
        self.contentOffset = CGPointMake(0, 106);
    }
    [UIView commitAnimations];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(0, -64);
    }];
    return [textField resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(0, -64);
    }];
    [_nameTextField resignFirstResponder];
    [_mobilTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_postTextField resignFirstResponder];
}
- (void)returnBackKeyboard
{
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(0, -64);
    }];
    [_nameTextField resignFirstResponder];
    [_mobilTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_postTextField resignFirstResponder];
}
#pragma mark - show Data
- (void)setAddressDic:(NSDictionary *)addressDic
{
    if (_addressDic != addressDic) {
        _addressDic = addressDic;
    }
    if (_addressDic != nil && _addressDic != NULL && _addressDic.count != 0) {
        _nameTextField.text = [_addressDic objectForKey:@"name"];
        _mobilTextField.text = [_addressDic objectForKey:@"mobile"];
        _addressTextField.text = [_addressDic objectForKey:@"address"];
        _postTextField.text = [_addressDic objectForKey:@"zipCode"];
    }
}


@end
