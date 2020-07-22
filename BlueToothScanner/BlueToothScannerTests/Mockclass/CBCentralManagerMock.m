//

#import "CBCentralManagerMock.h"

@implementation CBCentralManagerMock
- (instancetype)init {
    _mock = mock(CBCentralManagerMock.class);
    return self;
}

- (void)verifyPeripheralEquals:(CBPeripheral *) expected  {
    [verify(self.mock) connectPeripheral:expected
                                 options:anything()];
}
@end

