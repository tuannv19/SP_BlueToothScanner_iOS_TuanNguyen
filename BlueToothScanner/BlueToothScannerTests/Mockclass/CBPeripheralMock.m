//


#import "CBPeripheralMock.h"

@implementation CBPeripheralMock
- (instancetype)initWithUUID:(NSString *)UUID{
    self = [super init];
    if (self) {
        _mock = mock(CBPeripheral.class);
        NSUUID * uuid = [[NSUUID UUID] initWithUUIDString: UUID];
        [given(_mock.identifier) willReturn:uuid];
    }
    return self;
}
@end
