//
//  ABUUIDTextField.m
//  AprilBeacon
//
//  Created by liaojinhua on 14-8-8.
//  Copyright (c) 2014年 AprilBrother. All rights reserved.
//

#import "ABUUIDTextField.h"
#import "ABTransmitters.h"

@interface ABUUIDTextField () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIBarButtonItem *leftButton;
@property (nonatomic, strong) UIBarButtonItem *fixedBarButton;
@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) NSArray *uuidArray;

@end

@implementation ABUUIDTextField

- (instancetype)init
{
    if (self = [super init]) {
        [self addAssistantView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self addAssistantView];
    [self loadData];
}

- (void)hideFloatLabel
{
    self.floatingLabel.font = [UIFont systemFontOfSize:0];
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)hideLeftButton
{
    [self.toolbar setItems:@[self.fixedBarButton, self.rightButton]];
}

- (void)addAssistantView
{
    if (self.toolbar) {
        return;
    }
    self.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.toolbar.translucent = NO;
    self.leftButton = [[UIBarButtonItem alloc] initWithTitle:@"生成" style:UIBarButtonItemStylePlain target:self action:@selector(generate:)];
    self.fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"选择 UUID" style:UIBarButtonItemStylePlain target:self action:@selector(selectUUID:)];
    [self.toolbar setItems:@[self.leftButton, self.fixedBarButton, self.rightButton]];
    self.inputAccessoryView = self.toolbar;
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}
- (void)loadData
{
    _uuidArray = [[ABTransmitters sharedTransmitters] historyUUIDs];
}

- (void)generate:(id)sender
{
    if (self.inputView) {
        self.inputView = nil;
        self.leftButton.title = @"生成";
    } else {
        self.text = [[NSUUID UUID] UUIDString];
    }
    [UIView animateWithDuration:1.0f animations:^{
        [self reloadInputViews];
        [self becomeFirstResponder];
    }];
}

- (void)selectUUID:(id)sender
{
    [self endEditing:YES];
    
    if (self.inputView == self.pickerView) {
        self.inputView = nil;
        self.rightButton.title = @"选择 UUID";
        self.leftButton.title = @"生成";
        [UIView animateWithDuration:1.0f animations:^{
            [self reloadInputViews];
            [self becomeFirstResponder];
        }];
        return;
    }
    
    if (self.toolbar.items.count == 3) {
        self.leftButton.title = @"返回";
    } else {
        self.rightButton.title = @"返回";
    }
    
    self.inputView = self.pickerView;
    if (_uuidArray.count > 0) {
        self.text = [_uuidArray firstObject];
    }
    [self becomeFirstResponder];
}

- (NSString *)text
{
    return [[super text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row < _uuidArray.count) {
        self.text = _uuidArray[row];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _uuidArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _uuidArray[row];
}


@end
