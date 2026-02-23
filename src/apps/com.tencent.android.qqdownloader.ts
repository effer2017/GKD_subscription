import { defineGkdApp } from '@gkd-kit/define';

export default defineGkdApp({
  id: 'com.tencent.android.qqdownloader',
  name: '应用宝',
  groups: [
    {
      key: 1,
      name: '功能类-关闭登录弹窗',
      fastQuery: true,
      matchTime: 10000,
      actionMaximum: 1,
      resetMatch: 'app',
      rules: [
        {
          activityIds: 'com.tencent.assistantv2.activity.MainActivity',
          matches: '@Button[clickable=true] - [text="欢迎登录应用宝"]',
          exampleUrls:
            'https://m.gkd.li/57941037/29c109c2-7993-4b39-ba80-6ae6451ab533',
          snapshotUrls: 'https://i.gkd.li/i/16012576',
        },
      ],
    },
    {
      key: 2,
      name: '功能类-局部弹窗',
      fastQuery: true,
      matchTime: 10000,
      actionMaximum: 1,
      resetMatch: 'app',
      rules: [
        {
          activityIds: 'com.tencent.assistantv2.activity.MainActivity',
          matches:
            '@ImageView[childCount=0][visibleToUser=true][width<130 && height<130] <2 FrameLayout < FrameLayout < FrameLayout < [vid="c76"]',
          snapshotUrls: 'https://i.gkd.li/i/25282173',
        },
      ],
    },
    {
      key: 3,
      name: '功能类-签到弹窗',
      fastQuery: true,
      matchTime: 10000,
      actionMaximum: 1,
      resetMatch: 'app',
      rules: [
        {
          activityIds: 'com.tencent.assistantv2.kuikly.activity.TransparentKRCommonActivity',
          matches:
            '@ImageView[childCount=0][visibleToUser=true][width<64 && height<64] <3 FrameLayout < FrameLayout < FrameLayout < FrameLayout < [vid="c76"]',
          snapshotUrls: 'https://i.gkd.li/i/25473923',
        },
      ],
    },
  ],
});
