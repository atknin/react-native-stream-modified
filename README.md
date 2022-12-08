# react-native-stream-modified



# ORIGIN FROM  react-native-microphone-stream
React Native module used for two-way audio

## Install
```
$ npm i react-native-microphone-stream
```

### iOS
```
$ npx pod-install ios
```

## Usage
```typescript
import MicStream from 'react-native-microphone-stream';

const listener = MicStream.addListener(data => console.log(data));
MicStream.init({
  bufferSize: 4096,
  sampleRate: 44100,
  bitsPerChannel: 16,
  channelsPerFrame: 1,
});
MicStream.start();
MicStream.pause();
MicStream.stop();
listener.remove();
```




Версии 
1. Версия, которая не выключает воспроизведение звука 
2. Все хорошо, но осталась проблема - переключается в динамик
3. Снова переключает в динамик
4. Вроде бы исправленно, добавлена функция получения инфы о наушниках 



