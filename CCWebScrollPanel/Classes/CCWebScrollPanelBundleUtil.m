//
//  CCWebScrollPanelBundleUtil.m
//  CCWebScrollPanel
//
//  Created by DuZhixia on 2020/1/23.
//

#import "CCWebScrollPanelBundleUtil.h"

@implementation CCWebScrollPanelBundleUtil

+ (UIImage *)imageWithName:(NSString *)imageName
{
    return [UIImage imageNamed:imageName inBundle:[self imageBundle] compatibleWithTraitCollection:nil];
}

+ (NSBundle *)imageBundle
{
    static NSBundle *resourceBundle = nil;
    
    if (!resourceBundle) {
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                                    stringByAppendingPathComponent:@"/CCWebScrollPanel.bundle"];
        resourceBundle = [NSBundle bundleWithPath:bundlePath];
    }
    return resourceBundle;
}

@end
