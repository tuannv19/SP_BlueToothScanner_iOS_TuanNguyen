//
@import OCMockitoIOS;
@import OCHamcrestIOS;
@import CoreBluetooth;

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface CBCentralManagerMock: NSObject
@property(strong, nonatomic) CBCentralManager *mock;
@property(readonly, nonatomic) BOOL isScanning;
@property(readonly, nonatomic) NSInteger state;
@end

NS_ASSUME_NONNULL_END
