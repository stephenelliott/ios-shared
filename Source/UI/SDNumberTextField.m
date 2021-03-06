//
//  SDNumberTextField.m
//
//  Created by Brandon Sneed on 11/2/13.
//  Copyright (c) 2013 SetDirection. All rights reserved.
//

#import "SDNumberTextField.h"
#import "NSString+SDExtensions.h"

@interface SDNumberTextField ()
@property (nonatomic, copy) NSString *currentFormattedText;
@end

@implementation SDNumberTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:(CGRect)frame];
    if (self) {
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.format = @"#";
        [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.format = @"#";
    [self addTarget:self action:@selector(formatInput:) forControlEvents:UIControlEventEditingChanged];
}

- (NSString *)string:(NSString *)string withNumberFormat:(NSString *)format
{
    if (!string)
        return @"";

    return [string stringWithNumberFormat:format];
}

- (void)formatInput:(UITextField *)textField
{
    if (![textField.text isEqualToString:self.currentFormattedText])
    {
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            textField.text = [self.unformattedText stringWithNumberFormat:self.format];
            self.currentFormattedText = textField.text;
        });
    }
}

- (void)deleteBackward
{
    NSInteger decimalPosition = -1;
    for (NSInteger i = (NSInteger)self.text.length - 1; i > 0; i--)
    {
        NSString *c = [self.text substringWithRange:NSMakeRange((NSUInteger)i - 1, 1)];

        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:c];
        valid = [alphaNums isSupersetOfSet:inStringSet];

        if (valid)
        {
            decimalPosition = i;
            break;
        }
    }

    if (decimalPosition == -1)
        self.text = @"";
    else
        self.text = [self.text substringWithRange:NSMakeRange(0, decimalPosition)];

    self.currentFormattedText = self.text;
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (NSString *)unformattedText
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D" options:NSRegularExpressionCaseInsensitive error:NULL];
    return [regex stringByReplacingMatchesInString:self.text options:0 range:NSMakeRange(0, self.text.length) withTemplate:@""];
}

@end
