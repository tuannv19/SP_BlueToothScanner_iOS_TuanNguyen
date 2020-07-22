//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@import OCMockitoIOS;
@import OCHamcrestIOS;


NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheralMock: NSObject
@property(readonly, nonatomic) CBPeripheral *mock;

- (instancetype)initWithUUID:(NSString*)UUID;
@end

NS_ASSUME_NONNULL_END
