#import "YandexSignPlugin.h"
#import <yandex_sign_v2/yandex_sign_v2-Swift.h>

@implementation YandexSignPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYandexSignPlugin registerWithRegistrar:registrar];
}
@end
