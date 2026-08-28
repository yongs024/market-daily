# 일일 시황 대시보드

`market-dashboard/build_daily.py`가 만든 `index.html` 한 장만 담는 배포용 저장소다.
Vercel이 이 저장소의 main 브랜치를 보고 있어서, 푸시하면 자동으로 공개 URL이 갱신된다.

데이터 원본(daily_data.json · history · krx CSV)은 여기 올리지 않는다 — 용량이 크고
배포에 필요하지도 않다. 원본은 `market-dashboard/` 폴더에 그대로 둔다.

## 갱신 방법
`배포.bat` 더블클릭. add → commit → push 를 한 번에 한다.
