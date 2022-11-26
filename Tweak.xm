#include <substrate.h>
#include <dlfcn.h>
#import <Foundation/Foundation.h>
#import "fishhook.h"
#import <mach-o/dyld.h>
#include <pthread.h>
#import <os/lock.h>
#import <mach/thread_act.h>
#import <mach/mach_init.h>
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonCryptor.h>



bool isRequest = false;



static OSStatus * (*original_SecItemCopyMatching)(CFDictionaryRef query, CFTypeRef *result);



static OSStatus * replaced_SecItemCopyMatching(CFDictionaryRef query, CFTypeRef *result) {
        
        NSData *dResult;

        if (isRequest) {
                original_SecItemCopyMatching(query, result);
                dResult = (__bridge NSData*)(*result);
                NSString* oUUID = [[NSString alloc] initWithData:dResult encoding:NSUTF8StringEncoding];
                if (![oUUID isEqual:@"UDID"]) {
                        dResult = [@"UDID" dataUsingEncoding:NSUTF8StringEncoding];
                        if (result && *result) {
                                CFRelease(*result);
                        }

                        if (result) {
                                *result = CFBridgingRetain(dResult);
                        }
                }
                return 0;
        }
        else {
                return original_SecItemCopyMatching(query, result);
        }

}


%hook NSURLSession

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(id)completionHandler {
        NSURLRequest *hookUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.haxway.store/ipalibrary/crack.php"]];

        if ([[[request URL] absoluteString] containsString: @"ipalibrary.ru/appstore"]) {
                isRequest = true;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        isRequest = false;
                });
                return %orig(hookUrlRequest, completionHandler);
        }
        else {
                isRequest = false;
                return %orig;
        }
}

- (id)dataTaskWithURL:(NSURL *)url completionHandler:(id)completionHandler{
    NSURL *hookUrl = [NSURL URLWithString:@"https://api.haxway.store/ipalibrary/crack.php"];
    if ([[url absoluteString] containsString:@"ipalibrary.ru/appstore"])
    {
        isRequest = true;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        isRequest = false;
        });
        return %orig(hookUrl,completionHandler);
    }
    else {
        isRequest = false;
        return %orig;
    }
}

%end


%ctor {

        struct rebinding rebindings[] = {
                {"SecItemCopyMatching", (void *)replaced_SecItemCopyMatching, (void **)&original_SecItemCopyMatching}
        };

        rebind_symbols(rebindings, sizeof(rebindings) / sizeof(rebindings[0]));
}
