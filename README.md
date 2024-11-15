# unsupported-wifi-patches
Patches to fix old wireless cards support for MacOS Ventura - Sequoia

## Legacy WiFi Sources

   - airportd - MacOS Big Sur 11.7.10 - /usr/libexec || patched airportd for Sonoma 14.4+ only
   - wifip2pd - MacOS Monterey 12.7.6 - /usr/libexec
   - WiFiAgent.app - MacOS Big Sur 11.7.10 - /System/Library/CoreServices
   - wps - MacOS Monterey 12.7.6 - /usr/libexec
   - CoreWLAN - MacOS Monterey 12.7.6 - /System/Library/Frameworks/CoreWLAN.framework
   - CoreWiFi - MacOS Monterey 12.7.6 - /System/Library/PrivateFrameworks/CoreWiFi.framework
   - Apple80211 - MacOS Monterey 12.7.6 (renamed to IO80211 on Ventura) - /System/Library/PrivateFrameworks/Apple80211.framework
   - WiFiPeerToPeer - MacOS Monterey 12.7.6 - /System/Library/PrivateFrameworks/WiFiPeerToPeer.framework

## Modern WiFi Sources

   - airportd - MacOS Ventura 13.7.2 - /usr/libexec
   - wifip2pd - MacOS Ventura 13.7.2 - /usr/libexec
   - CoreWLAN - MacOS Ventura 13.7.2 - /System/Library/Frameworks/CoreWLAN.framework
   - CoreWiFi - MacOS Ventura 13.7.2 - /System/Library/PrivateFrameworks/CoreWiFi.framework
   - IO80211 - MacOS Ventura 13.7.2 - /System/Library/PrivateFrameworks/IO80211.framework
   - WiFiPeerToPeer - MacOS Ventura 13.7.2 - /System/Library/PrivateFrameworks/WiFiPeerToPeer.framework
   - WiFiAgent.app - MacOS Sonoma 14.7.2 - /System/Library/CoreServices || 15.0+ only