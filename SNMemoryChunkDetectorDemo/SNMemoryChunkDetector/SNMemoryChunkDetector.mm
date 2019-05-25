//
//  SNMemoryChunkDetector.m
//  SNMemoryChunkDetector
//
//  Created by asnail on 2019/4/11.
//

#include "SNMemoryChunkDetector.h"

#define ra_stack_logging_type_alloc         2    /* malloc, realloc, etc... */
#define ra_stack_logging_type_dealloc       4    /* free, realloc, etc... */
#define ra_stack_logging_type_vm_allocate   16   /* vm_allocate or mmap */
#define ra_stack_logging_type_vm_deallocate 32   /* vm_deallocate or munmap */
#define ra_stack_logging_flag_zone          8    /* NSZoneMalloc, etc... */
#define ra_stack_logging_flag_cleared       64   /* for NewEmptyHandle */
#define ra_stack_logging_type_mapped_file_or_shared_mem 128

typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);

extern malloc_logger_t *malloc_logger;

void ra_common_stack_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip);

static BOOL g_mem_chunk_start;
static size_t g_chunk_threshhold;

@interface SNMemoryChunkDetector ()

@property (nonatomic, copy) RAChunkMallocBlock callback;

@end

@implementation SNMemoryChunkDetector

static SNMemoryChunkDetector *_sharedDetector;
+ (instancetype)sharedDetector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDetector = [SNMemoryChunkDetector new];
    });
    return _sharedDetector;
}

- (BOOL)startSingleChunkMallocDetector:(size_t)threshholdInBytes callback:(RAChunkMallocBlock)callback {
    if (g_mem_chunk_start) {
        return YES;
    }
    g_mem_chunk_start = YES;
    
    g_chunk_threshhold = threshholdInBytes;
    //register malloc_logger.
    malloc_logger = (malloc_logger_t *)ra_common_stack_logger;//(malloc_logger_t *)ra_common_stack_logger;
    self.callback = callback;
    return g_mem_chunk_start;
}

- (void)stopSingleChunkMallocDetector {
    if(g_mem_chunk_start){
        g_mem_chunk_start = NO;
        malloc_logger = NULL;
    }
}

void ra_common_stack_logger(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t backtrace_to_skip)
{
    if (!g_mem_chunk_start) {
        return;
    }
    
    if (type & ra_stack_logging_flag_zone) {
        type &= ~ra_stack_logging_flag_zone;
    }
    uintptr_t chunk = 0;
    if (type == (ra_stack_logging_type_dealloc | ra_stack_logging_type_alloc)) {
        if(arg3 > g_chunk_threshhold){
            chunk = arg3;
        }
    }
    else if((type & ra_stack_logging_type_alloc) != 0) {
        if(arg2 > g_chunk_threshhold){
            chunk = arg2;
        }
    }
    
    //result callback.
    if (chunk && [SNMemoryChunkDetector sharedDetector].callback) {
        [SNMemoryChunkDetector sharedDetector].callback(chunk);
    }
}

@end
