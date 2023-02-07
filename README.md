# 주제 : 항공 서비스에 대한 만족을 높이는 요인

부제 : 독립성검정, 로지스틱회귀분석 등의 ‘범주형 자료분석’방법을 활용하여 고객의 만족도를 높일 수 있는 요인 찾기

#### 사용한 분석 도구 : R

#### 데이터 분석 프로세스 : 데이터 수집-데이터 전처리-EDA-분할표 및 독립성 검정-로지스틱 회귀분석-모델 평가
### Object
<img src="https://user-images.githubusercontent.com/76424262/217273596-fca28f39-0b6c-4bf3-9e8e-b1b28a7ccada.PNG">

- 2021년 11월, 대한민국의 '위드 코로나' 시행으로 여행객들의 기대감이 높아져 한공 산업이 다시 눈을 뜨고 있음.
- 고객이 항공사 서비스에 대해 만족도를 높이는 요인들을 찾아 니즈를 파악하고 이에 따른 인사이트를 도출하고자 함.

### PreProcessing
<img src="https://user-images.githubusercontent.com/76424262/217278427-d4c91091-834c-4d88-b857-0a80c66f3b4a.PNG">

- x,id와 같은 고유의 값 변수 제거
- Arrival.Delay.in.Minutes변수에서 83개의 결측값 확인, 이후 결측값을 제거하였음
- 만족도 척도(1~5)에 해당하지 않는 값을 결측치로 판단하여 제거
- Departure Delay in Minutes와 Arrival Delay in Minutes에 이상치가 존재하는 데이터들 제거(나이와 비행거리는 이상치가 존재하지만 의미가 있을 것 같아 제거하지 않았음)
- 출발,도착 지연 시간Arrival Delay in Minutes와 Departure Delay in Minutes 차이를 계산하여 파생변수(ontime)생성(Arrival.Delay.in.Minutes-Departure.Delay.in.Minutes)


### EDA
<img src="https://user-images.githubusercontent.com/76424262/217280656-b697360e-bdd1-4022-b6ae-2f8d14412e97.PNG">

- 성별 : 두 범주 모두 여성 응답자가 남성보다 많았지만 남성과 여성 만족 여부 비율 비슷
- 나이 : 25~50세의 청, 중장년층쪽에서 빈도가 높음

<img src="https://user-images.githubusercontent.com/76424262/217280805-3e609805-0022-42eb-b00e-0a74d89cb63e.PNG">
<img src="https://user-images.githubusercontent.com/76424262/217280987-52773ad6-91e8-4d92-971b-4e855a55238a.PNG">
<img src="https://user-images.githubusercontent.com/76424262/217281106-04e9045e-f3c9-404d-9c59-d6be8ee8d3a3.PNG">

### Statistical Methodology

#### Chi-square test of independence
<img src="https://user-images.githubusercontent.com/76424262/217283244-3852b179-aafe-4587-ac8c-0a9a24e6a7ae.PNG">

- 만족 여부를 두고 각 변수들과의 카이제곱검정에 의해 gender 변수를 제외한 모든 변수에서 종속 관계를 가짐

#### GLM
<img src="https://user-images.githubusercontent.com/76424262/217285031-a16aefd4-dbcf-432e-912b-0de5076e7b4e.PNG">

- Flight.Distance, Seat.comfort, Inflight.entertainment에서 귀무가설을 채택하여 로지스틱 모형에 유의하지 않음
- 절편이 없는 모형을 설정하여 Likelyhood Ratio검정을 실시, p-value가 0.001보다 작으므로 귀무가설을 기각하여 독립변수들 사이에 다중공선성이 존재
- 다중공선성에 의해 모형이 과적합되는 문제를 해결하기 위해 Stepwise Variable Selection, Backward Elimination 사용
- 변수 선택법에 의해 Flight.Distance, Inflight.entertainment, Seat.comfort, Departure Delay in Minutes,Arrival Delay in Minutes, ontime 변수를 제외한 모형을 최종 모형으로 채택

<img src="https://user-images.githubusercontent.com/76424262/217285209-4c1b2b3e-590d-4790-a97f-f4b7d1e7d03a.PNG">
#### Model Assessment

<img src="https://user-images.githubusercontent.com/76424262/217285401-3929727d-f0e7-4708-9e9b-8425ba9e6397.PNG">

### Result
