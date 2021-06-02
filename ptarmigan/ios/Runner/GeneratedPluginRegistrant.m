//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<amplify_core/AmplifyCorePlugin.h>)
#import <amplify_core/AmplifyCorePlugin.h>
#else
@import amplify_core;
#endif

#if __has_include(<amplify_datastore/AmplifyDataStorePlugin.h>)
#import <amplify_datastore/AmplifyDataStorePlugin.h>
#else
@import amplify_datastore;
#endif

#if __has_include(<amplify_flutter/Amplify.h>)
#import <amplify_flutter/Amplify.h>
#else
@import amplify_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AmplifyCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"AmplifyCorePlugin"]];
  [AmplifyDataStorePlugin registerWithRegistrar:[registry registrarForPlugin:@"AmplifyDataStorePlugin"]];
  [Amplify registerWithRegistrar:[registry registrarForPlugin:@"Amplify"]];
}

@end
