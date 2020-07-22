//
@import OCMockitoIOS;
@import OCHamcrestIOS;
@import CoreBluetooth;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface CBCentralManagerMock: NSObject
@property(readonly, nonatomic) CBCentralManager *mock;
@end

NS_ASSUME_NONNULL_END
