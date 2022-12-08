declare module 'react-native-microphone-stream' {
  export interface RNMicrophoneStreamOptions {
    bufferSize: number;
    sampleRate: number;
    bitsPerChannel: number;
    channelsPerFrame: number;
  }

  const RNMicrophoneStream: {
    init: (options: RNMicrophoneStreamOptions) => void,
    addListener: (listener: (data: Uint8Array) => void) => { remove: () => void };
    start: () => void;
    pause: () => void;
    stop: () => void;
  };

  export default RNMicrophoneStream;
}
