PC_ARR=("nate.com" "news.nate.com" "pann.nate.com" "mail3.nate.com" "tv.nate.com" "shopping.nate.com")
MOBILE_ARR=("m.nate.com" "m.news.nate.com" "m.pann.nate.com" "m.mail.nate.com" "tv.nate.com" "m.shopping.nate.com")

pc_func() {
  date=$(date +%Y-%m-%d)
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

for pc in "${PC_ARR[@]}"; do
    pc_func $pc
done

for mobile in "${MOBILE_ARR[@]}"; do
  mobile_func $mobile
done