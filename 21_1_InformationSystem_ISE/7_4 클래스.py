# dash 패키지 설치
import dash # 서버와 관련
import dash_html_components as html
# ㄴ이걸 해줘야 html 코드를 쓸 수 있음
from dash.dependencies import Output, Input
import dash_core_components as dcc
import pandas as pd
import plotly.express as px # 차트 그리는 모듈 불러오기
import ise4032_class_210521 as ise # 생성한 .py 파일 임포트




def load_data():
    # ORDER Table
    df_order = pd.read_excel('DB_Structure.xlsx', sheet_name='ORDER')
    # CUSTOMER Table
    df_customer = pd.read_excel('DB_Structure.xlsx', sheet_name='CUSTOMER')
    # STOCK Table
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')



    # Customer를 Member와 비Member로 구분
    cust_list = []
    for index, row in df_customer.iterrows():
        if row['MEMBER'] == 'NO': # 멤버가 아닌 사람
            cust = ise.Customer(row['CUST_LNAME'], row['CUST_FNAME'])  # DB_Structure로부터 직접 불러옴
            cust.id = row['CUST_ID']
            cust.reg_date = row['REG_DATE']
            cust.birth_date = row['BIRTH_DATE']
            cust.gender = row['GENDER']
            cust_list.append(cust)  # 리스트로 갖다 붙임
        else: # 멤버인 경우
            cust = ise.Member(row['CUST_LNAME'], row['CUST_FNAME'], row['REG_DATE'])  # Memeber class에서 불러옴
            cust.id = row['CUST_ID']
            cust.reg_date = row['REG_DATE']
            cust.birth_date = row['BIRTH_DATE']
            cust.gender = row['GENDER']
            cust_list.append(cust)
            # 클래스에 pass를 써버리면 그대로 읽어옴, Member 클래스에 변수 아무것도 없는데도 Customer 거 그대로 가져옴
            # 근데 이러면 상속하는 의미가 없으니 다시 클래스로 가서 수정

    item_list = []
    for index, row in df_stock.iterrows():
        item = ise.Item(row['ITEM_ID'])
        item.type = row['ITEM_NAME']
        item.price = row['PRICE']
        item.quantity = row['QTY']
        item.last_updated = row['LAST_UPDATED']
        item_list.append(item)

    item_list_new = list(filter(lambda x: x.price >= 70000, item_list))

    for index, row in df_order.iterrows():
        item_id = row['ITEM_ID']
        cust_id = row['CUST_ID']
        # 이대로 두면 id는 읽어오는데 그걸 어찌 쓸 방법이 없음
        # so, lambda 식 활용!
        cust = list(filter(lambda x: x.id == cust_id, cust_list))[0]
        # 필터 걸어서 현재 반복 중인 cust_id와 매치되는 고객을 cust 변수에 저장
        # 똑같은 방식으로 item도 찾음
        item = list(filter(lambda x: x.id == item_id, item_list))[0]
        # 만약 cust_id나 item_id가 없다면, 빈 list로 반환해버림

        cust.consume(item, row['ITEM_QTY'], row['ORDER_DATE'])




    print('debug')

if __name__ == "__main__":
    load_data()
