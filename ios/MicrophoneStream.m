#import "MicrophoneStream.h"

@implementation MicrophoneStream {
    AudioQueueRef _queue;
    AudioQueueBufferRef _buffer;
    AVAudioSessionCategory _category;
    AVAudioSessionMode _mode;

    NSNumber *_audioData[65536];
    UInt32 _bufferSize;
}

void inputCallback(
        void *inUserData,
        AudioQueueRef inAQ,
        AudioQueueBufferRef inBuffer,
        const AudioTimeStamp *inStartTime,
        UInt32 inNumberPacketDescriptions,
        const AudioStreamPacketDescription *inPacketDescs) {
    [(__bridge MicrophoneStream *) inUserData processInputBuffer:inBuffer queue:inAQ];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(init:(NSDictionary *) options) {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // _category = [session category];
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:[session categoryOptions]|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
//    [session setPreferredInput:[session.availableInputs firstObject] error:nil];
//    NSLog(@"obj: %", [session.availableInputs firstObject]);
//    [session setActive:true error:nil];
    _mode = [session mode];

    UInt32 bufferSize = options[@"bufferSize"] == nil ? 8192 : [options[@"bufferSize"] unsignedIntegerValue];
    _bufferSize = bufferSize;

    AudioStreamBasicDescription description;
    description.mReserved = 0;
    description.mSampleRate = options[@"sampleRate"] == nil ? 44100 : [options[@"sampleRate"] doubleValue];
    description.mBitsPerChannel = options[@"bitsPerChannel"] == nil ? 16 : [options[@"bitsPerChannel"] unsignedIntegerValue];
    description.mChannelsPerFrame = options[@"channelsPerFrame"] == nil ? 1 : [options[@"channelsPerFrame"] unsignedIntegerValue];
    description.mFramesPerPacket = options[@"framesPerPacket"] == nil ? 1 : [options[@"framesPerPacket"] unsignedIntegerValue];
    description.mBytesPerFrame = options[@"bytesPerFrame"] == nil ? 2 : [options[@"bytesPerFrame"] unsignedIntegerValue];
    description.mBytesPerPacket = options[@"bytesPerPacket"] == nil ? 2 : [options[@"bytesPerPacket"] unsignedIntegerValue];
    description.mFormatID = kAudioFormatLinearPCM;
    description.mFormatFlags = kAudioFormatFlagIsSignedInteger;

    AudioQueueNewInput(&description, inputCallback, (__bridge void *) self, NULL, NULL, 0, &_queue);
    AudioQueueAllocateBuffer(_queue, (UInt32) (bufferSize * 2), &_buffer);
    AudioQueueEnqueueBuffer(_queue, _buffer, 0, NULL);
}

RCT_EXPORT_METHOD(start) {
    AVAudioSession *session = [AVAudioSession sharedInstance];
//    for (NSObject *obj in session.outputDataSources) {
        
//    }
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetoothA2DP|AVAudioSessionCategoryOptionAllowBluetooth error:nil];
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:[session categoryOptions]|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    
//    [session setActive:true error:nil];
    
    NSLog(@"obj2: %@", [session currentRoute]);
    NSLog(@"obj22: %@", session.availableInputs);
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
//    [session setPreferredInput:[session.availableInputs lastObject] error:nil];
//    [session setInputDataSource:(nullable AVAudioSessionDataSourceDescription *) error:nil];
//    for (NSObject *obj in session.availableInputs) {
//        NSLog(@"obj: %@", obj);
//    }
    
//    [session setActive:true error:nil];
    AudioQueueStart(_queue, NULL);
}

RCT_EXPORT_METHOD(getRoute:(RCTResponseSenderBlock)callback)
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSLog(@"obj2: %@", [session currentRoute]);
    callback([session currentRoute]);
}

//RCT_EXPORT_METHOD(getRoute:(RCTPromiseResolveBlock)resolve
//                  rejecter:(RCTPromiseRejectBlock)reject)
//{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//
//    NSLog(@"obj2: %@", [session currentRoute]);
//    resolve([session currentRoute]);
//}

RCT_EXPORT_METHOD(pause) {
    AudioQueuePause(_queue);
    AudioQueueFlush(_queue);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // [session setCategory:_category
    //                error:nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
//    [session setPreferredInput:[session.availableInputs firstObject] error:nil];
//    NSLog(@"obj: %", [session.availableInputs firstObject]);
//    [session setActive:true error:nil];
    [session setMode:_mode
               error:nil];
}

RCT_EXPORT_METHOD(stop) {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // [session setCategory:_category
    //                error:nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
//    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    
//    [session setPreferredInput:[session.availableInputs firstObject] error:nil];
//    NSLog(@"obj: %", [session.availableInputs firstObject]);
//    [session setActive:true error:nil];
    [session setMode:_mode
               error:nil];
    AudioQueueStop(_queue, YES);
}

- (void)processInputBuffer:(AudioQueueBufferRef)inBuffer queue:(AudioQueueRef)queue {
    SInt16 *audioData = inBuffer->mAudioData;
    UInt32 count = inBuffer->mAudioDataByteSize / sizeof(SInt16);
    for (int i = 0; i < _bufferSize; i++) {
        _audioData[i] = @(audioData[i]);
    }
    [self sendEventWithName:@"audioData" body:[NSArray arrayWithObjects:_audioData count:count]];
    AudioQueueEnqueueBuffer(queue, inBuffer, 0, NULL);
}

- (NSArray<NSString *> *)supportedEvents {
    return @[@"audioData"];
}

- (void)dealloc {
    AudioQueueStop(_queue, YES);
}

@end
