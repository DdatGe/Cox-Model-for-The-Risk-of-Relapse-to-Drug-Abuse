#  Cox Model for The Risk of Relapse to Drug Abuse

## 📌 프로젝트 소개
[cite_start]이 프로젝트는 **약물 중독 치료 후 재발까지 걸리는 시간에 영향을 주는 요인을 분석**하기 위한 생존분석(Survival Analysis) 프로젝트입니다. [cite: 5]
[cite_start]단순한 재발 여부를 넘어 '재발 시점'을 반영하기 위해 **Cox Proportional Hazards Model**을 적용했습니다. [cite: 5] [cite_start]이후 모델 가정(Log-linearity, Proportional hazards)을 진단하고, 한계를 보완하기 위해 치료 기간(`treat`)을 기준으로 층화한 **Stratified Cox Model**을 최종 모형으로 채택했습니다. [cite: 489]

## 📊 데이터셋 소개
* [cite_start]**출처:** 1989~1994년 미국 매사추세츠 약물 중독자 예방 프로그램 연구 [cite: 8]
* [cite_start]**표본 수:** 575명 / **변수 수:** 8개 [cite: 21]

| 변수명 | 설명 | 비고 |
|---|---|---|
| **days** | 치료 시작 후 재발 또는 검열(censoring)까지의 일수 | [cite_start]반응 변수 [cite: 11] |
| **relapse** | 재발 여부 | [cite_start]1 = 재발, 0 = 검열 [cite: 12] |
| **treat** | 계획된 치료 기간 | [cite_start]0 = 3개월, 1 = 6개월 [cite: 13] |
| **age** | 치료 시작 시 나이 | [cite_start]연속형 [cite: 14] |
| **race** | 인종 | [cite_start]0 = white, 1 = others [cite: 15] |
| **num** | 이전 약물 치료 횟수 | [cite_start]연속형 [cite: 16] |
| **use** | 최근 3개월간 약물 사용 유형 | [cite_start]1=둘 다, 2=헤로인만, 3=코카인만, 4=둘 다 안 함 [cite: 17] |
| **dep** | 치료 시작 시 우울 점수 (Beck score) | [cite_start]점수가 높을수록 우울 정도가 심함 [cite: 18] |

## 🛠 분석 파이프라인 & 모델링

### 1. 탐색적 데이터 분석 (EDA)
* [cite_start]변수 간 강한 상관관계는 발견되지 않았습니다. [cite: 53]
* [cite_start]**Kaplan-Meier (KM) 곡선:** 대부분의 공변량에서 그룹 간 생존 시간의 차이가 확인되었으나, `use` 변수는 곡선이 많이 겹쳐 예측력이 낮을 것으로 판단했습니다. [cite: 334, 335]

### 2. 변수 선택 (Model Selection)
* [cite_start]전체 변수를 넣은 초기 모형에서 **Stepwise selection (Forward, Backward, Both)** 및 **AIC**를 기준으로 최적 모형을 탐색했습니다. [cite: 343, 344]
* [cite_start]그 결과, 가장 작은 AIC(5299.550)를 기록한 `treat + age + race + num + dep` 조합을 초기 모형으로 선택했습니다. [cite: 349]

### 3. 가정 진단 및 모델 개선 (Diagnostics)
* [cite_start]**Log-linearity (로그선형성):** 초기 모형 진단 결과, `treat` 변수에서 가정이 위배되는 것을 확인했습니다. [cite: 372]
* [cite_start]**Proportional Hazards (비례위험):** Schoenfeld residual test 결과, 모든 변수의 p-value가 0.05 이상으로 가정을 만족했습니다. [cite: 386]
* [cite_start]**모델 개선:** 로그선형성 문제를 해결하기 위해, `treat` 변수를 층화 변수(strata)로 설정하여 그룹별로 기저위험(Baseline hazard)을 다르게 허용하는 **Stratified Cox Model**을 적합했습니다. [cite: 428] [cite_start]수정한 모형은 모든 가정을 만족했습니다. [cite: 469]

## 📈 최종 모형 및 주요 결과

### 🧪 Stratified Cox Proportional Hazards Model
$$h_i(t) = h_{i0}(t)\exp(\beta_1\text{age} + \beta_2\text{race} + \beta_3\text{num} + \beta_4\text{dep})$$
[cite_start]*(단, $i=0$: 3개월 치료 그룹, $i=1$: 6개월 치료 그룹)* [cite: 491, 493]

### 💡 핵심 인사이트
[cite_start]최종 모형 분석 결과, 유의미하게 나타난 재발 위험 요인은 다음과 같습니다. [cite: 494]
* [cite_start]**나이 (`age`):** 나이가 1살 증가할수록 재발 위험(hazard)이 약 **2.1% 감소**합니다. [cite: 498]
* [cite_start]**인종 (`race`):** Non-white 참가자의 재발 위험은 white 참가자 대비 **77.6% 수준**입니다. [cite: 499]
* [cite_start]**과거 치료 횟수 (`num`):** 이전 치료 횟수가 1회 추가될 때마다 재발 위험이 약 **3.4% 증가**합니다. [cite: 500]
* [cite_start]**우울 점수 (`dep`):** 우울 점수가 1점 높아질수록 재발 위험이 **1.06% 증가**합니다. [cite: 502]

> [cite_start]**결론적으로, 과거 치료 경험이 많고 우울 수준이 높을수록 재발 위험이 커지며, 나이가 많을수록 재발 위험은 낮아지는 경향을 보였습니다.** [cite: 501, 534]

## ⚠️ 한계점
* [cite_start]본 분석은 특정 시기(1989~1994년)와 지역(매사추세츠)의 데이터셋을 기반으로 하므로, 결과를 모든 약물 중독 집단에 일반화하기 어렵습니다. [cite: 8]
* Stepwise 선택법은 직관적이나 변수 선택의 안정성 측면에서 한계가 존재할 수 있습니다.
* 변수들 간의 복잡한 인과관계를 완벽히 규명하기보다는 연관성과 위험 요인을 파악하는 데 초점을 맞추었습니다.

## 💻 사용 기술 및 레포지토리 구조
* [cite_start]**Language:** R (Libraries: `survival`, `timereg`, `survminer`) [cite: 537, 538, 563]

```text
├── data/              # 원본 데이터
├── 01_eda.R           # 데이터 구조 확인 및 기초 탐색적 분석
├── 02_km_curve.R      # Kaplan-Meier 생존곡선 시각화
├── 03_cox_modeling.R  # Cox model 적합 및 stepwise 선택
├── 04_diagnostics.R   # 로그선형성 및 비례위험 가정 진단
├── 05_final_model.R   # Stratified Cox model 적합 및 최종 결과 확인
├── report/            # 프로젝트 보고서
└── README.md
