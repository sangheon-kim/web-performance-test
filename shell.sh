#!/bin/bash

re="^([A-Za-z\.]{0,}(\:*\d+)*)\/*"

export PATH=${PATH}
# Please Input Your PC Web Site List
# PC_ARR=("nate.com" "news.nate.com/view/20200309n34198" "pann.nate.com/talk/353507871" "tv.nate.com/clip/4025004" "daum.net/" "naver.com/" "news.v.daum.net/v/20200309171218432" "news.naver.com/main/read.nhn?mode=LSD&mid=sec&sid1=105&oid=079&aid=0003333554")
PC_ARR=("nate.com" "news.nate.com/view/20200309n34198" "pann.nate.com/talk/353507871" "tv.nate.com/clip/4025004")
# Please Input Your Mobile Web Site List
MOBILE_ARR=("m.nate.com" "m.news.nate.com/view/20200309n34198" "m.pann.nate.com/talk/353507871
" "tv.nate.com/clip/4025004")
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
  
  # echo $s1
  url=$1
  
  if [[ $url =~ $re ]]; then 
    filename=${BASH_REMATCH[1]}; 
  fi

  mkdir -p result/$date/$throttleFolder
 
  touch result/$date/$throttleFolder/pc_$filename\.$ext
  
  $(which lighthouse) https://$url \
    --chrome-flags="--headless" \
    --output=$ext \
    --output-path=./result/$date/$throttleFolder/pc_$filename.$ext \
    --screenEmulation.disabled \
    --no-emulatedUserAgent \
    --form-factor=desktop \
    --only-categories=performance \
    --throttling.cpuSlowdownMultiplier=$default_throttling_pc \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240

  return
}

# default Mobile Test Function
mobile_func() {
  url=$1

  if [[ $url =~ $re ]]; then 
    filename=${BASH_REMATCH[1]}; 
  fi

  mkdir -p result/$date/$throttleFolder
  touch result/$date/$throttleFolder/m_$filename\.$ext

  lighthouse https://$url --chrome-flags="--headless" --output=$ext \
    --output-path=./result/$date/$throttleFolder/m_$filename.$ext \
    --only-categories=performance

  return
}

# Hight Performance Desktop Test Function
pc_no_throttling_func() {
  url=$1

  if [[ $url =~ $re ]]; then 
    filename=${BASH_REMATCH[1]}; 
  fi
  
  mkdir -p result/$date/$highPerformance
  touch result/$date/$highPerformance/pc_$filename\.$ext
  
  lighthouse https://$url \
    --chrome-flags="--headless" \
    --output=$ext --output-path=./result/$date/$highPerformance/pc_$filename.$ext \
    --screenEmulation.disabled \
    --no-emulatedUserAgent \
    --form-factor=desktop \
    --only-categories=performance \
    --throttling.cpuSlowdownMultiplier=$highPerformance_throttling_pc \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240

  return   
}

# Hight Performance Mobile Test Function
mobile_no_throttling_func() {
  url=$1

  if [[ $url =~ $re ]]; then 
    filename=${BASH_REMATCH[1]}; 
  fi
  
  mkdir -p result/$date/$highPerformance
  touch result/$date/$highPerformance/m_$filename\.$ext

  lighthouse https://$url --chrome-flags="--headless" \
    --output=$ext --output-path=./result/$date/$highPerformance/m_$filename.$ext \
    --only-categories=performance \
    --throttling.cpuSlowdownMultiplier=$highPerformance_throttling_mobile \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240

  return
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

$(which npm) run start