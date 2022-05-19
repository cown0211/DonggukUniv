import pandas as pd
import math
from bs4 import BeautifulSoup # Ctrl + Space beautifulsoup 선택
from urllib.request import urlopen
# 패키지 beautifulsoup4, requests 설치
from datetime import date # 기본 패키지

# 패키지 plotly 설치
import plotly.express as px # 차트 그리는 모듈 불러오기


def load_data():

    # ORDER Table
    df_order = pd.read_excel('DB_Structure.xlsx', sheet_name='ORDER')
    # CUSTOMER Table
    df_customer = pd.read_excel('DB_Structure.xlsx', sheet_name='CUSTOMER')
    # STOCK Table
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')

    # 새 DF 생성 - ORDER와 STOCK을 조합, ORDER에 STOCK을 붙이는 식
    df_new = df_stock.set_index('ITEM_ID').join(df_order.set_index('ITEM_ID'))  # ITEM_ID가 키값이 되어 index 붙음
    #df_new2 = df_order.set_index('ITEM_ID').join(df_stock.set_index('ITEM_ID'))
    # 위는 stock에 order를 붙인 형식, 아래는 order에 stock을 붙인 형식
    df_new = df_new.set_index('CUST_ID').join(df_customer.set_index('CUST_ID'))
    # CUST_ID로 구분이 어려우니 이름을 불러오기 위한 작업


    df_new['TOTAL_PRICE'] = df_new['PRICE'] * df_new['ITEM_QTY']
    # total_price라는 새 열 생성
    if (df_new['BIRTH_DATE'])

    df_new['BIRTHDAY']
    print('debug')

    # 반응형 차트 생성
    fig = px.scatter(df_new, title="ISE_4032 Sales Record", x='ORDER_DATE', y='TOTAL_PRICE', color='ITEM_NAME',
                  hover_name='PAY_METHOD', hover_data=['QTY'])
    fig.update_traces(mode="markers")
    fig.show()

    print('hello')

if __name__ == '__main__':
    load_data()
