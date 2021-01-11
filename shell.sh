PC_ARR=("nate.com" "news.nate.com" "pann.nate.com" "mail3.nate.com" "tv.nate.com" "shopping.nate.com")
MOBILE_ARR=("m.nate.com" "m.news.nate.com" "m.pann.nate.com" "m.mail.nate.com" "tv.nate.com" "m.shopping.nate.com")
date=$(date +%Y-%m-%d)

pc_func() {
  url=$1
  ext=\.json
  mkdir -p $date
  touch $date/$url\.json
  
  lighthouse https://$url \
    --chrome-flags="--headless" \
    --output=json \
    --output-path=./$date/$url.json \
    --screenEmulation.disabled \
    --no-emulatedUserAgent \
    --form-factor=desktop \
    --throttling.cpuSlowdownMultiplier=3.5 \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240
}

mobile_func() {
  url=$1

  lighthouse https://$url --chrome-flags="--headless" --output=json --output-path=./$date/$url.json
}

pc_no_throttling_func() {
  url=$1
  ext=\.json
  mkdir -p $date-no
  touch $date-no/$url\.json
  
  lighthouse https://$url \
    --chrome-flags="--headless" \
    --output=json --output-path=./$date-no/$url.json \
    --screenEmulation.disabled \
    --no-emulatedUserAgent \
    --form-factor=desktop \
    --throttling.cpuSlowdownMultiplier=1 \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240
    
}

mobile_no_throttling_func() {
  url=$1
  ext=\.json
  mkdir -p $date-no
  touch $date-no/$url\.json

  lighthouse https://$url --chrome-flags="--headless" \
    --output=json --output-path=./$date-no/$url.json \
    --throttling.cpuSlowdownMultiplier=2 \
    --throttling-method=devtools \
    --throttling.requestLatencyMs=40 \
    --throttling.downloadThroughputKbps=10240 \
    --throttling.uploadThroughputKbps=10240
}

for pc in "${PC_ARR[@]}"; do
    pc_func $pc
done

for mobile in "${MOBILE_ARR[@]}"; do
  mobile_func $mobile
done

for pc in "${PC_ARR[@]}"; do
  pc_no_throttling_func $pc
done

for mobile in "${MOBILE_ARR[@]}"; do
  mobile_no_throttling_func $mobile
done