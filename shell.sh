#!/bin/sh

# Please Input Your PC Web Site List
PC_ARR=("nate.com" "news.nate.com" "pann.nate.com" "tv.nate.com" "shopping.nate.com")
# Please Input Your Mobile Web Site List
MOBILE_ARR=("m.nate.com" "m.news.nate.com" "m.pann.nate.com" "tv.nate.com" "m.shopping.nate.com")
# Today Date
date=$(date +%Y-%m-%d)
# throttle Folder Name  
throttleFolder="default"
highPerformance="high"

# Please input one of [html, csv, json] Filename extension 
ext=json

# This is default CPU_throttling Speed (setting value in Chrome Extension Lighthouse is same)
default_throttling_pc=3.5
# High Performance Device Test(pc)
highPerformance_throttling_pc=1
# High Performance Device Test(mobile)
highPerformance_throttling_mobile=2

# default Desktop Test Function 
pc_func() {
  url=$1
  mkdir -p result/$date/$throttleFolder
 
  touch result/$date/$throttleFolder/pc_$url\.$ext
  
  lighthouse https://$url \
    --chrome-flags="--headless" \
    --output=$ext \
    --output-path=./result/$date/$throttleFolder/pc_$url.$ext \
    --screenEmulation.disabled \
    --no-emulatedUserAgent \
    --form-factor=desktop \
    --throttling.cpuSlowdownMultiplier=$default_throttling_pc \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240
}

# default Mobile Test Function
mobile_func() {
  url=$1

  mkdir -p result/$date/$throttleFolder
  touch result/$date/$throttleFolder/m_$url\.$ext

  lighthouse https://$url --chrome-flags="--headless" --output=$ext --output-path=./result/$date/$throttleFolder/m_$url.$ext
}

# Hight Performance Desktop Test Function
pc_no_throttling_func() {
  url=$1
  
  mkdir -p result/$date/$highPerformance
  touch result/$date/$highPerformance/pc_$url\.$ext
  
  lighthouse https://$url \
    --chrome-flags="--headless" \
    --output=$ext --output-path=./result/$date/$highPerformance/pc_$url.$ext \
    --screenEmulation.disabled \
    --no-emulatedUserAgent \
    --form-factor=desktop \
    --throttling.cpuSlowdownMultiplier=$highPerformance_throttling_pc \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240
    
}

# Hight Performance Mobile Test Function
mobile_no_throttling_func() {
  url=$1
  
  mkdir -p result/$date/$highPerformance
  touch result/$date/$highPerformance/m_$url\.$ext

  lighthouse https://$url --chrome-flags="--headless" \
    --output=$ext --output-path=./result/$date/$highPerformance/m_$url.$ext \
    --throttling.cpuSlowdownMultiplier=$highPerformance_throttling_mobile \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240
}

# loop pc_func execute (put in your PC_ARR element)
for pc in "${PC_ARR[@]}"; do
    pc_func $pc
done

for pc in "${PC_ARR[@]}"; do
    pc_no_throttling_func $pc
done

for mobile in "${MOBILE_ARR[@]}"; do
  mobile_func $mobile
done

for mobile in "${MOBILE_ARR[@]}"; do
  mobile_no_throttling_func $mobile
done

npm run start
# yarn start