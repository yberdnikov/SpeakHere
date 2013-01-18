//
//  COMMON.h
//  SpeakHere
//
//  Created by 耿 建峰 on 12-1-16.
//  Copyright (c) 2012年 信通科技. All rights reserved.
//

#ifndef SpeakHere_COMMON_h
#define SpeakHere_COMMON_h

typedef enum{
    REQUEST_GOOGLE_AUDIO = 0, // 谷歌语音识别
}REQUESTTYPE;

// google语音识别
#define GOOGLE_AUDIO_URL @"http://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=zh-CN"

#endif
