importScripts('workbox-v6.5.4/workbox-sw.js');
importScripts('https://cdn.onesignal.com/sdks/OneSignalSDKWorker.js');

workbox.precaching.precacheAndRoute(self.__WB_MANIFEST);
