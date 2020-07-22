//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@import OCMockitoIOS;
@import OCHamcrestIOS;


NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheralMock: NSObject
@property(readonly, nonatomic) CBPeripheral *mock;

- (instancetype)initWithUUID:(NSString*)UUID;
- (instancetype)initWithUUID:(NSString*)UUID name:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
