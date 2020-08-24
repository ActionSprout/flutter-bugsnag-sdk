#import "SnagbugPlugin.h"
#if __has_include(<snagbug/snagbug-Swift.h>)
#import <snagbug/snagbug-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "snagbug-Swift.h"
#endif

@implementation SnagbugPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSnagbugPlugin registerWithRegistrar:registrar];
}
@end
