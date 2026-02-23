import { defineGkdApp } from '@gkd-kit/define';

export default defineGkdApp({
  id: 'com.eastmoney.android.choice',
  name: 'Choice数据',
  groups: [
    {
      key: 1,
      name: '通知提示',
      fastQuery: true,
      matchTime: 10000,
      actionMaximum: 1,
      resetMatch: 'app',
      rules: [
        {
          activityIds:
            'com.eastmoney.android.module.launcher.internal.home.HomeActivity',
          matches: '[text="下次再说"][id="android:id/button2"]',
          snapshotUrls: 'https://i.gkd.li/i/25474369',
        },
      ],
    },
  ],
});
