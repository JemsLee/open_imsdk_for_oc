
#import "ITWebSocket.h"
#import "SRWebSocket.h"

#import "LinkQueue.h"
#import "Node.h"

@interface ITWebSocket ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;

@property (nonatomic,assign)ITSocketStatus itSocketStatus;

@property (nonatomic,weak)NSTimer *timer;
@property (nonatomic,weak)NSTimer *looptimer;

@property (nonatomic,copy)NSString *urlString;

@property (nonatomic,strong)Observable *obs;

@property (nonatomic,assign)bool lostIsSending;
///构造链式队列
@property (nonatomic,strong)LinkQueue *linkQueue ;

@end

@implementation ITWebSocket{
    NSInteger _reconnectCounter;
}



+ (instancetype)shareManager{
    static ITWebSocket *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 3;
        instance.loopovertime = 3;
        instance.reconnectCount = 5;
    });
    return instance;
}

- (void)inits:(Observable *)fobs{
    _obs = fobs;
    _linkQueue = [LinkQueue constrcutLinkQueue];
    _lostIsSending = NO;
}


- (void)itOpen:(NSString *)urlStr connect:(ITSocketDidConnectBlock)connect receive:(ITSocketDidReceiveBlock)receive failure:(ITSocketDidFailBlock)failure{
    [ITWebSocket shareManager].connect = connect;
    [ITWebSocket shareManager].receive = receive;
    [ITWebSocket shareManager].failure = failure;
    [self itOpen:urlStr];
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(itCheckStatus) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
    [self.timer fire];
    
    if(self.looptimer){
        [self.looptimer invalidate];
        self.looptimer = nil;
    }
    
    NSTimer *looptimer = [NSTimer scheduledTimerWithTimeInterval:self.loopovertime target:self selector:@selector(itSendLost) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:looptimer forMode:NSRunLoopCommonModes];
    self.timer = looptimer;
    [self.timer fire];
}

- (void)itClose:(ITSocketDidCloseBlock)close{
    [ITWebSocket shareManager].close = close;
    [self itClose];
}

// Send a UTF8 String or Data.
- (void)itSend:(id)data{
    switch ([ITWebSocket shareManager].itSocketStatus) {
        case ITSocketStatusConnected:
        case ITSocketStatusReceived:{
            [self.webSocket sendString:data error:NULL];
            break;
        }
        case ITSocketStatusFailed:{
            Node *nodeFailed = [[Node alloc] initWithData:data];
            [_linkQueue enQueueWithNode:nodeFailed];
            [self itReconnect];
            break;
        }
        case ITSocketStatusClosedByServer:{
            Node *nodeFailed = [[Node alloc] initWithData:data];
            [_linkQueue enQueueWithNode:nodeFailed];
            [self itReconnect];
            break;
        }
        case ITSocketStatusClosedByUser:
            break;
    }
    
}

#pragma mark -- private method
- (void)itOpen:(id)params{

    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
    }
    [ITWebSocket shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    
    [self.webSocket open];
}

- (void)itClose{
    
    [self.webSocket close];
    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)itReconnect{
    [self itOpen:self.urlString];
}

- (void)itCheckStatus{
    if(self.webSocket != nil){
        if([self.webSocket readyState] == SR_CLOSED){
            NSLog(@"The client is trying to connect to the IM server");
            [self->_obs notifyStatusObservers:@"{\"status\":\"1\",\"desc\":\"Networking error,Reconnecting\""];
            [self itReconnect];
        }
    }
}

- (void)itSendLost{
    if(self.webSocket != nil && !_lostIsSending){
        _lostIsSending = YES;
        while ([_linkQueue eleCount] > 0) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self itSend:[self->_linkQueue deQueue].data];
             });
        }
        _lostIsSending = NO;
    }
}

#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [ITWebSocket shareManager].connect ? [ITWebSocket shareManager].connect() : nil;
    [ITWebSocket shareManager].itSocketStatus = ITSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    [_obs notifyObservers:error.description];
    [ITWebSocket shareManager].itSocketStatus = ITSocketStatusFailed;
    [ITWebSocket shareManager].failure ? [ITWebSocket shareManager].failure(error) : nil;
}
//
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    [ITWebSocket shareManager].itSocketStatus = ITSocketStatusReceived;
    [ITWebSocket shareManager].receive ? [ITWebSocket shareManager].receive(message,ITSocketReceiveTypeForMessage) : nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if (reason) {
        [ITWebSocket shareManager].itSocketStatus = ITSocketStatusClosedByServer;
    }
    else{
        [ITWebSocket shareManager].itSocketStatus = ITSocketStatusClosedByUser;
    }
    [ITWebSocket shareManager].close ? [ITWebSocket shareManager].close(code,reason,wasClean) : nil;
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [ITWebSocket shareManager].receive ? [ITWebSocket shareManager].receive(pongPayload,ITSocketReceiveTypeForPong) : nil;
}

- (void)dealloc{
    // Close WebSocket
    [self itClose];
}

@end
