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

### if you change ext to html in shell script, it appears in html file, and if you look at it, you can see the same result as the lighthouse extension. (셸스크립트 안에 ext를 html로 변경하면 html파일로 나오는데 그것을 보시면 라이트하우스 확장프로그램 돌린것과 똑같은 결과를 볼 수 있습니다.)

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

### V 1.1.0 release Note

- To correct the overwrite phenomenon in the same domain, modify prefix to m\_ desktop in front of file name for test to pc\_ (동일 도메인의 경우에 overwrite되는 현상 수정을 위해 prefix로 모바일의 경우 파일명 앞에 m\_ 데스크탑으로 테스트의 경우 pc\_ 붙혀주는것으로 수정)

- Extract result.json based on the key value you put in the whiteList array in the JavaScript file (자바스크립트 파일에 whiteList 배열에 넣어놓은 키값을 기준으로 result.json 추출)

- Add a throttle option based on the assumption of high performance equipment(high Performance 장비를 가정으로한 throttling 옵션 추가)

- Archive the results json file in the result folder (result 폴더에 결과 json 파일 보관)
