//
//  AppDelegateInfoTransferProtocol.h
//  iStore Commercial
//
//  Created by Ryan Britt on 11/9/11.
//  Copyright (c) 2011 Ryan Britt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"

@protocol AppDelegateInfoTransferProtocol <NSObject>
-(AppData *) anyTransferredAppData;
@end
