# 주제 : 항공 서비스에 대한 만족을 높이는 요인

부제 : 독립성검정, 로지스틱회귀분석 등의 ‘범주형 자료분석’방법을 활용하여 고객의 만족도를 높일 수 있는 요인 찾기

사용한 패키지 : R

데이터 분석 프로세스 : 데이터 수집-데이터 전처리-EDA-분할표 및 독립성 검정-로지스틱 회귀분석-모델 평가
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
<img src="https://user-images.githubusercontent.com/76424262/217280805-3e609805-0022-42eb-b00e-0a74d89cb63e.PNG">
<img src="https://user-images.githubusercontent.com/76424262/217280987-52773ad6-91e8-4d92-971b-4e855a55238a.PNG">
<img src="https://user-images.githubusercontent.com/76424262/217281106-04e9045e-f3c9-404d-9c59-d6be8ee8d3a3.PNG">

### Statistical Methodology

#### 
#### GLM

### Result
