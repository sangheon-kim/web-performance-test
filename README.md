# Lighthouse Automation (라이트하우스 자동화)

- Customise the shell script code and rotate it the way you want. (셸 스크립트 코드를 커스텀하여서 원하는 방식대로 돌려보세요)

### Sangheon Kim(ksj8367@gmail.com)

### Version 1.0.0

## Usage

`1. Please install lighthouse Module in global`

```bash
$ npm install -g lighthouse
```

`2. execute Shell`

```bash
$ sh shell.sh
```

### 셸스크립트 안에 ext를 html로 변경하면 html파일로 나오는데 그것을 보시면 라이트하우스 확장프로그램 돌린것과 똑같은 결과를 볼 수 있습니다.

```bash
  lighthouse https://$url \
    --chrome-flags="--headless" \ # This option can be optional(optional : see Chrome Browser)
    --output=$ext \ # Output filename extension
    --output-path=./$date/$throttleFolder/pc_$url.$ext \ # Output filename extension
    --screenEmulation.disabled \ # Desktop Option
    --no-emulatedUserAgent \ # Desktop Option
    --form-factor=desktop \ # Desktop Option
    --throttling.cpuSlowdownMultiplier=$default_throttling_pc \ # CPU Throttling
    --throttling-method=devtools \ #Throttling Method
    --throttling.requestLatencyMs=40 \ # Network Throttling
    --throttling.downloadThroughputKbps=10240 \ # Network Throttling
    --throttling.uploadThroughputKbps=10240 # Network Throttling
```
