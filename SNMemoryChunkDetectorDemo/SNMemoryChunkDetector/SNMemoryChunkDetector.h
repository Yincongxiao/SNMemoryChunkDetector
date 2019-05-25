//
//  SNMemoryChunkDetector.h
//  SNMemoryChunkDetector
//
//  Created by asnail on 2019/4/11.
//

#ifndef SNMemoryChunkDetector_hpp
#define SNMemoryChunkDetector_hpp
#import <Foundation/Foundation.h>

typedef void (^RAChunkMallocBlock)(size_t bytes);

@interface SNMemoryChunkDetector : NSObject

+ (instancetype)sharedDetector;

/**
 start memory single chunk detector with threshhold limit.

 @param threshholdInBytes threshhold limit of memory
 @param callback callback when memory chunk over threshholdInBytes
 @return start success or not.
 */
- (BOOL)startSingleChunkMallocDetector:(size_t)threshholdInBytes callback:(RAChunkMallocBlock)callback;

/**
 stop memory chunk malloc detector.
 */
- (void)stopSingleChunkMallocDetector;

@end

#endif /* SNMemoryChunkDetector_h */
