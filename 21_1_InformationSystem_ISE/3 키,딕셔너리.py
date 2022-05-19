import pandas as pd
#pandas를 pd로 불러오기
import math


def load_data(): #함수정의

    # 딕셔너리 정의1
    europe = {'spain':'madrid','france':'paris'} # 중괄호에 하나하나 욱여넣기

    # 딕셔너리 정의2
    europe = {} #중괄호 넣고
    europe['spain'] = 'madrid'  # 대괄호에 key 값, 등호 뒤에 해당 값
    europe['spain'] = 'barcelona' # 이렇게 하면 뒤의 값으로 덮어써버림
    europe['france'] = 'paris'
    europe['germany'] = 'berlin'

    # State, Number => Composite
    # 딕셔너리 안에 딕셔너리 넣기!
    # reg_num = {'key':'value'}  #value에 딕셔너리!
    reg_num = {'spain':{'capital':'madrid','population':46.77},'france':{'capital':'paris','population':66.03}}

    # 딕셔너리는 보기 어렵! -> data_frame
    reg_df = pd.DataFrame(reg_num)


    # ORDER Table
    df_order = pd.read_excel('DB_Structure.xlsx',sheet_name='ORDER')
    # CUSTOMER Table
    df_customer = pd.read_excel('DB_Structure.xlsx',sheet_name='CUSTOMER')
    # STOCK Table
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')


    # 해당 값이 unique 한가 확인!
    unique_values = df_customer.CUST_ID.unique() # 값 추출
    # 추출한 값이 series인지 확인? 하단 variables에서 확인!
    unique_okay = df_customer['CUST_ID'].is_unique # 값이 TRUE면 모두 unique 함

    # 해당 값이 unique 하다면 해당 열을 key로 설정!
    if df_customer['CUST_ID'].is_unique :
        df_customer_new = df_customer.set_index('CUST_ID')
        # CUST_ID가 unique 하다면 CUST_ID를 인덱스로 설정! 해당 열은 날아가버림


    result = pd.DataFrame(columns=list(df_order.columns))
    validity = df_order.isnull().any().any()


    OID_cnt = 1

    # popped_attr = df_order.pop('ORDER_ID')
    for index, row in df_order.iterrows():
        if math.isnan(row['ORDER_ID']):
            row['ORDER_ID'] = OID_cnt
            OID_cnt += 1
        # ORDER_ID 값이 nan이라면 OID_cnt 값을 대입하라!
        # 근데 OID_cnt는 더해져가는데 해당 열에 대입이 안됨


    print(df_order[df_order.ITEM_QTY > 5])


if __name__ == '__main__':
    load_data()
