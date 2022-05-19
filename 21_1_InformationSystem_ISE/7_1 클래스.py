# dash 패키지 설치
import dash # 서버와 관련
import dash_html_components as html
# ㄴ이걸 해줘야 html 코드를 쓸 수 있음
from dash.dependencies import Output, Input
import dash_core_components as dcc
import pandas as pd
import plotly.express as px # 차트 그리는 모듈 불러오기
import ise4032_class as ise # 생성한 .py 파일 임포트




def load_data():
    # ORDER Table
    df_order = pd.read_excel('DB_Structure.xlsx',sheet_name='ORDER')
    # CUSTOMER Table
    df_customer = pd.read_excel('DB_Structure.xlsx',sheet_name='CUSTOMER')
    # STOCK Table
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')


    cust_1 = ise.Customer(f_name='dongsu',l_name='kim') # cust_1에 클래스 할당
    # cust_1.number = 2
    cust_2 = ise.Customer()    # cust_1.number = 2 수행하면 cust_1.number는 2로 수정되고, cust_2.number는 1임
    cust_3 = ise.Customer()


    print('debug')

if __name__ == "__main__":
    load_data()
