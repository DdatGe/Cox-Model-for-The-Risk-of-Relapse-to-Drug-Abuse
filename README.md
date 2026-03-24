# Cox-Model-for-The-Risk-of-Relapse-to-Drug-Abuse

## 프로젝트 소개
이 프로젝트는 약물 중독 치료 후 **재발까지 걸리는 시간**에 영향을 주는 요인을 분석하기 위해 수행한 생존분석 프로젝트입니다.  
단순히 재발 여부만 보는 것이 아니라, **재발이 언제 발생하는지**까지 반영하기 위해 Cox proportional hazards model을 적용했습니다.  
또한 모델 적합 이후 로그선형성(log-linearity)과 비례위험 가정(proportional hazards assumption)을 진단하고, 초기 모형의 한계를 보완하기 위해 **treat 변수를 기준으로 층화한 stratified Cox model**을 최종 모형으로 선택했습니다.

## 분석 배경 및 문제 정의
약물 중독 치료에서는 단순히 재발 여부만큼이나 **재발까지 걸리는 시간**이 중요합니다.  
같은 재발이라도 치료 직후 빠르게 재발하는 경우와 오랜 기간 유지하다 재발하는 경우는 위험 해석이 다르기 때문입니다.  
이 프로젝트에서는 치료 기간, 나이, 인종, 이전 치료 횟수, 최근 약물 사용 형태, 우울 점수 등이 재발 위험에 어떤 영향을 미치는지 분석했습니다.

본 프로젝트에서는 다음 질문을 다루었습니다.

- 어떤 변수들이 약물 중독 재발 위험에 유의한 영향을 미치는가?
- Cox proportional hazards model의 가정은 데이터에 적절한가?
- 가정이 위배되는 경우, 어떻게 모델을 수정하여 더 타당한 해석을 할 수 있는가?

## 데이터
- **데이터 출처**: 1989~1994년 미국 매사추세츠 약물 중독자 예방 프로그램 연구
- **표본 수**: 575명
- **변수 수**: 8개
- **분석 목적**: 치료 시작 후 약물 재발까지의 시간과 위험 요인 분석

### 변수 설명
- `days`: 치료 시작 후 재발 또는 검열까지의 일수
- `relapse`: 재발 여부 (1 = 재발, 0 = 검열)
- `treat`: 계획된 치료 기간 (0 = 3개월, 1 = 6개월)
- `age`: 치료 시작 시 나이
- `race`: 인종 (0 = white, 1 = others)
- `num`: 이전 치료 횟수
- `use`: 최근 3개월간 약물 사용 유형
- `dep`: 치료 시작 시 우울 점수(Beck score)

## 분석 방법
본 프로젝트는 다음과 같은 흐름으로 진행했습니다.

1. **탐색적 데이터 분석(EDA)**
   - 변수 요약통계와 히스토그램 확인
   - 변수 간 상관관계 점검
   - 설명변수와 반응변수 간 강한 선형 상관이 있는지 확인

2. **Kaplan-Meier 곡선 확인**
   - 각 공변량별 KM survival curve를 통해 생존시간 차이를 시각적으로 비교
   - 연속형 변수는 평균 기준으로 그룹화하여 비교
   - 대부분의 변수는 그룹 간 차이가 보였지만, `use` 변수는 곡선이 많이 겹쳐 상대적으로 중요성이 낮을 가능성을 확인

3. **Cox 비례위험모형 적합 및 변수 선택**
   - 전체 변수로 Cox model 적합
   - stepwise selection(forward, backward, both)과 AIC를 이용해 후보 모형 비교
   - 최종 후보 변수로 `treat`, `age`, `race`, `num`, `dep` 선택

4. **모형 가정 진단**
   - log-linearity 진단
   - Schoenfeld residual 기반 proportional hazards assumption 검정
   - 초기 선택 모형에서는 `treat` 변수에서 로그선형성 문제가 확인됨

5. **Stratified Cox model로 보완**
   - `treat`를 층화 변수로 두어 treatment 그룹별 baseline hazard가 다를 수 있도록 모델 수정
   - 수정 후 로그선형성과 비례위험 가정이 모두 만족되는지 다시 확인

## 모델 선택 과정
KM curve 확인 결과 `use` 변수는 그룹 간 곡선이 많이 겹쳐 예측력이 낮을 가능성이 있었고,  
이를 바탕으로 stepwise model selection을 수행했습니다. AIC 비교 결과 최종 후보모형은 아래와 같았습니다.

- `step both`: treat + age + race + num + dep
- `step back`: treat + age + race + num + dep
- `step for`: treat + age + race + num + use + dep

이 중 가장 작은 AIC를 보인 모형은 `treat + age + race + num + dep`였고, 이를 초기 선택 모형으로 채택했습니다.

## 진단 및 모델 개선
초기 Cox 모형에 대해 로그선형성과 비례위험 가정을 점검한 결과,  
Schoenfeld residual test에서는 전체적으로 PH 가정 위배가 나타나지 않았지만, `treat` 변수는 로그선형성 측면에서 문제가 확인되었습니다.
이를 해결하기 위해 `treat` 변수를 기준으로 층화한 **stratified Cox model**을 다시 적합했습니다.  
이후 진단 결과에서는

- 모든 공변량에 대해 로그선형성이 만족되었고
- Schoenfeld residual test의 p-value가 모두 0.05보다 커서
- 비례위험 가정도 만족하는 것으로 확인되었습니다. :contentReference[oaicite:5]{index=5}

즉, 최종적으로는 treatment 그룹에 따라 baseline hazard를 다르게 허용한 stratified Cox model이 더 적절한 모형으로 판단되었습니다.

## 최종 모형
최종 모형은 `treat`를 기준으로 층화한 stratified Cox proportional hazards model입니다.  
모형은 다음과 같은 형태입니다. 

- strata: `treat`
- covariates: `age`, `race`, `num`, `dep`

즉, treatment 기간(3개월 / 6개월)에 따라 baseline hazard는 다르게 두되,  
나이, 인종, 이전 치료 횟수, 우울 점수가 재발 위험에 미치는 효과를 추정했습니다.

## 주요 결과
최종 stratified Cox model에서 유의하게 나타난 변수는 다음과 같습니다.

- **age**: 나이가 1살 증가할수록 hazard가 약 2.1% 감소  
  → 나이가 많을수록 재발 위험이 다소 낮아짐

- **race**: non-white 참가자의 hazard는 white 참가자의 약 77.6%  
  → 인종 변수에 따라 재발 위험 차이가 존재

- **num**: 이전 치료 횟수가 1회 증가할수록 hazard가 약 3.4% 증가  
  → 과거 치료 경험이 많을수록 재발 위험이 높음

- **dep**: 우울 점수가 1 증가할수록 hazard가 증가  
  → 우울 수준이 높을수록 재발 위험이 커짐

즉, 이 프로젝트에서는 **이전 치료 경험과 우울 수준이 재발 위험을 높이는 방향으로 작용하고**,  
반대로 **나이는 재발 위험을 낮추는 방향으로 작용**한다는 점을 확인했습니다. 또한 치료 기간 변수는 단순 공변량으로 넣기보다 **층화 변수로 처리하는 것이 더 타당**하다는 점을 확인했습니다.


## 한계
- 본 프로젝트는 특정 연구 데이터셋을 기반으로 한 분석으로, 결과를 모든 약물 중독 집단에 일반화하는 데에는 한계가 있습니다.
- stepwise selection은 해석이 직관적이지만, 변수 선택의 안정성 측면에서는 한계가 있을 수 있습니다.
- 인과관계 규명보다는 재발 위험과 공변량 간의 연관성 및 예측 구조를 이해하는 데 초점을 두었습니다.

## 사용 기술
- **Language**: R
- **Libraries**:
  - `survival`
  - `timereg`
  - `survminer`

## 레포지토리 구성 예시
```bash
├── data/              # 원본 데이터
├── scripts/           # EDA, KM curve, Cox model, diagnostic 코드
├── outputs/           # survival plot, residual plot, 결과표
├── report/            # 프로젝트 보고서
└── README.md
