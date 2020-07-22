//

#import "CBCentralManagerMock.h"

@implementation CBCentralManagerMock
- (instancetype)init {
    _mock = mock(CBCentralManagerMock.class);
    [given(_mock.isScanning) willReturnBool:self.isScanning];
    [given(_mock.state) willReturnInteger:self.state];
//    [givenVoid([self->_mock stopScan]) willDo:^id (NSInvocation * invocation) {
//        return ^{};
//    }];
    return self;
}
- (void)setState:(CBManagerState)state{
    [given(_mock.state) willReturnInteger:state];
}

- (void)verifyPeripheralEquals:(CBPeripheral *) expected  {
    [verify(self.mock) connectPeripheral:expected
                                 options:anything()];
}

@end

