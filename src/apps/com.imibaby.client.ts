import { defineGkdApp } from '@gkd-kit/define';

export default defineGkdApp({
  id: 'com.imibaby.client',
  name: '米兔',
  groups: [
    {
      key: 1,
      name: '评价提示',
      fastQuery: true,
      matchTime: 10000,
      actionMaximum: 1,
      resetMatch: 'app',
      rules: [
        {
          activityIds: 'com.xiaoxun.xun.activitys.AppScoreActivity',
          matches:
            '@ImageView[clickable=true][focusable=true][visibleToUser=true] < ViewGroup < [id="android:id/content"]',
          snapshotUrls: 'https://i.gkd.li/i/25473982',
        },
      ],
    },
  ],
});
