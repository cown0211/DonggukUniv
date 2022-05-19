# dash 패키지 설치
import dash # 서버와 관련
import dash_html_components as html
# ㄴ이걸 해줘야 html 코드를 쓸 수 있음
from dash.dependencies import Output, Input
import dash_core_components as dcc
import pandas as pd
import plotly.express as px # 차트 그리는 모듈 불러오기
import ise4032_class_210507 as ise # 생성한 .py 파일 임포트




def load_data():
    # ORDER Table
    df_order = pd.read_excel('DB_Structure.xlsx', sheet_name='ORDER')
    # CUSTOMER Table
    df_customer = pd.read_excel('DB_Structure.xlsx', sheet_name='CUSTOMER')
    # STOCK Table
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')


    cust_1 = ise.Customer(f_name='dongsu',l_name='kim') # cust_1에 클래스 할당
    # cust_1.number = 2
    cust_2 = ise.Customer(f_name='sanghyeok',l_name='kim')    # cust_1.number = 2 수행하면 cust_1.number는 2로 수정되고, cust_2.number는 1임
    # ise.Customer.store_name="my store" # 여기서 이렇게 넣으면 모든 cust에게 적용됨
    # 전체 class가 공유하는 자리에 변수 넣어놨기 때문
    cust_3 = ise.Customer(f_name='juhyeong',l_name='chae')


    # class끼리 list 생성 가능
    cust_list = []  # 빈 list 생성
    cust_list.append(cust_1)
    cust_list.append(cust_2)
    cust_list.append(cust_3)
    # class list는 함수형 프로그래밍을 위해 하는 것

    # 예를 들어 id가 1인 고객을 찾는 예시에서
    for cust in cust_list:
        if cust.id == 1:
            id1_cust = cust
    # for, if문 써도 되나 너무 더럽

    id1_cust = cust_list[1-1]
    # 이렇게 해도 되나 순서 뒤집어 넣으면 개망
    # 여기까지만 보면 for문으로 가는게 맞으나 l_name = 'kim'인 사람을 찾는다고 해보자



    for cust in cust_list:
        if cust.last_name == 'kim':
            id1_cust = cust
    # kim 씨를 다 찾으려 했으나 마지막 값으로 덮어써버림 (김상혁) 대참사...
    # 이럴 때 람다(lambda) 활용; 코드를 최소화 하도록!


    # 위 방식대로 kim 씨 다 찾으려면
    kim_list = []
    for cust in cust_list:
        if cust.last_name == 'kim':
            kim_list.append(cust)
    # 이걸 한 줄로 줄여보고자 함

    kim_list = list(filter(lambda x: x.last_name == 'kim', cust_list))
    # lambda 활용하여 한 줄로 줄여버림!





    # Customer Table을 통해 Customer 클래스 리스트 생성
    cust_list = []
    for index, row in df_customer.iterrows():
        cust = ise.Customer(row['CUST_LNAME'], row['CUST_FNAME'])  # DB_Structure로부터 직접 불러옴
        cust.id = row['CUST_ID']
        cust.reg_date = row['REG_DATE']
        cust.birth_date = row['BIRTH_DATE']
        cust.gender = row['GENDER']
        cust.member = row['MEMBER']
        cust_list.append(cust)  # 리스트로 갖다 붙임

    cust_list_new = list(filter(lambda x: x.member == "YES", cust_list))
    # lambda 식으로 list를 필터링

    item_list = []
    for index, row in df_stock.iterrows():
        item = ise.Item(row['ITEM_ID'])
        item.type = row['ITEM_NAME']
        item.price = row['PRICE']
        item.quantity = row['QTY']
        item.last_updated = row['LAST_UPDATED']
        item_list.append(item)

    item_list_new = list(filter(lambda x: x.price >= 70000, item_list))

    cust_list[0].consume(item_list[0])

    print('debug')

if __name__ == "__main__":
    load_data()
