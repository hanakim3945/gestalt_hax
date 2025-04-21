//
//  patcher.m
//  GestaltHax
//
//  Created by Hana on 15/03/24.
//


#include <stdio.h>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <dlfcn.h>
#include <string.h>


off_t find_offset(const char* mgKey) {
    const struct mach_header_64 *header = NULL;
    const char *mgName = "/usr/lib/libMobileGestalt.dylib";
    dlopen(mgName, RTLD_GLOBAL);

    for (int i = 0; i < _dyld_image_count(); i++) {
        if (!strncmp(mgName, _dyld_get_image_name(i), strlen(mgName))) {
            header = (const struct mach_header_64 *)_dyld_get_image_header(i);
            break;
        }
    }
    
    assert(header);

    // Locate the obfuscated key
    size_t textCStringSize;
    const char *textCStringSection = (const char *)getsectiondata(header, "__TEXT", "__cstring", &textCStringSize);
    for (size_t size = 0; size < textCStringSize; size += strlen(textCStringSection + size) + 1) {
        if (!strncmp(mgKey, textCStringSection + size, strlen(mgKey))) {
            textCStringSection += size;
            break;
        }
    }

    // Locate the unknown struct
    size_t constSize;
    const uintptr_t *constSection = (const uintptr_t *)getsectiondata(header, "__AUTH_CONST", "__const", &constSize);
    if (!constSection) {
        constSection = (const uintptr_t *)getsectiondata(header, "__DATA_CONST", "__const", &constSize);
    }

    for (int i = 0; i < constSize / sizeof(uintptr_t); i++) {
        if (constSection[i] == (uintptr_t)textCStringSection) {
            constSection += i;
            break;
        }
    }

    // Calculate the offset
    off_t offset = (off_t)((uint16_t *)constSection)[0x9a / 2] << 3;
    return offset;
}

void patch_buffer(unsigned char *buffer, size_t size) {
    if (!buffer || size == 0) {
        fprintf(stderr, "Invalid buffer or size.\n");
        return;
    }

    // EffectiveSecurityModeAp
    off_t offset1 = find_offset("vENa/R1xAXLobl8r3PBL6w");

    // Patch the fourth 0x10 byte to 0x00
    if (offset1 != -1 && offset1 < size) {
        buffer[offset1] = 0x00;
    } else {
        printf("Could not find enough 0x01 bytes or patch offset out of range.\n");
    }

    // EffectiveProductionStatusAp
    off_t offset2 = find_offset("AQiIpW0UeYQKnhy2da7AXg");

    // Patch the fourth 0x10 byte to 0x00
    if (offset2 != -1 && offset2 < size) {
        buffer[offset2] = 0x00;
    } else {
        printf("Could not find enough 0x01 bytes or patch offset out of range.\n");
    }
    
    NSLog(@"Found EffectiveSecurityModeAp offset at: %#05llx", offset1);
    NSLog(@"Found EffectiveProductionStatusAp offset at: %#05llx ", offset2);

    NSLog(@"Patching done.");
}




@interface PlistModifier : NSObject
- (void)modifyPlistAtPath:(NSString *)path;
@end

@implementation PlistModifier

- (NSData *)modifyCacheData:(NSData *)cacheData {
    if (!cacheData || [cacheData length] == 0) {
        NSLog(@"Invalid or empty cache data.");
        return cacheData;
    }

    // Convert NSData to a mutable buffer
    NSUInteger size = [cacheData length];
    unsigned char *buffer = malloc(size);
    if (!buffer) {
        NSLog(@"Memory allocation failed.");
        return cacheData;
    }
    [cacheData getBytes:buffer length:size];

    // Call the patch_buffer function
    patch_buffer(buffer, size);

    // Convert the modified buffer back to NSData
    NSData *modifiedData = [NSData dataWithBytes:buffer length:size];

    // Free the buffer
    free(buffer);

    return modifiedData;
}


- (void)modifyPlistAtPath:(NSString *)path {
    // Load plist file
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (!plistDict) {
        NSLog(@"Failed to load plist at path: %@", path);
        return;
    }

    // Extract CacheData key
    NSData *cacheData = plistDict[@"CacheData"];
    if (!cacheData || ![cacheData isKindOfClass:[NSData class]]) {
        NSLog(@"CacheData key is missing or invalid in plist.");
        return;
    }

    // Modify CacheData
    NSData *modifiedData = [self modifyCacheData:cacheData];

    // Update plist with modified data
    plistDict[@"CacheData"] = modifiedData;

    // Save back to file
    if ([plistDict writeToFile:path atomically:YES]) {
        NSLog(@"Successfully modified and saved plist.");
    } else {
        NSLog(@"Failed to save plist at path: %@", path);
    }
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 2) {
            NSLog(@"Usage: patcher <path_to_plist>");
            return 1;
        }
        
        NSString *plistPath = [NSString stringWithUTF8String:argv[1]];
        PlistModifier *modifier = [[PlistModifier alloc] init];
        [modifier modifyPlistAtPath:plistPath];
    }
    return 0;
}
