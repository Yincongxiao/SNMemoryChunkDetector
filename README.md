### SNMemoryChunkDetector
## 
`SNMemoryChunkDetector` is a simple detector for memory malloc chunk in iOS. 
## Usage
```
//Appdelegete.m
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    int bPerM = 1024 * 1024;
    [[SNMemoryChunkDetector sharedDetector] startSingleChunkMallocDetector:50 * bPerM callback:^(size_t bytes) {
        NSLog(@"checked memory chunk: %@MB", @(bytes / bPerM));
    }];
    return YES;
}
```

