#import "BugsnagPlugin.h"
#if __has_include(<bugsnag/bugsnag-Swift.h>)
#import <bugsnag/bugsnag-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bugsnag-Swift.h"
#endif

@implementation BugsnagPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBugsnagPlugin registerWithRegistrar:registrar];
}
@end
