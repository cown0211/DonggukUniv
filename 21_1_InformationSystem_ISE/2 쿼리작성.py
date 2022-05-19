import pandas as pd
#pandas를 pd로 불러오기


def load_data(): #함수정의
    df_order = pd.read_excel('DB_Structure.xlsx', sheet_name='ORDER')
    df_customer = pd.read_excel('DB_Structure.xlsx', sheet_name='CUSTOMER')
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')

    # key as an UNIQUE attribute -> identifier
    print(df_order.keys())   # attribute 조회하고 싶을 때 .keys() 함수 사용



    # ITEM_QTY 값이 5를 초과하는 query 작성
    print(df_order.query('ITEM_QTY > 5'))
    # 위와 같은 식 다른 표현
    print(df_order[df_order.ITEM_QTY > 5])


    # 값을 지정하지 않고 객체로 설정할 경우
    a = 5
    print(df_order.query('ITEM_QTY > ' + str(a)))
    # 1안의 경우 '' 표시로 객체 앞에서 구분을 해줘야 함
    print(df_order[df_order.ITEM_QTY > a])



    '''
    디버깅 가서 Variables 좌측에 변수 추가 가능
    df_order.ORDER_ID.isnull() 
    df_order의 ORDER_ID라는 attribute가 null인지 반환
    '''


    # 여기서는 전부 null이란 걸 알지만 확인하는 방법은?
    # 위의 isnull() 뒤에 .any() 함수 추가
    Validity = df_order.ORDER_ID.isnull().any()
    print(Validity)
    # 결과가 True라면 전부 다 null(True)라는 의미
    print(not Validity) # 다른 표현식


    order_id_backup = df_order.pop('ORDER_ID')
    print(order_id_backup)  # .pop()은 기존 거에서 떼어오는 의미, 기존거로 가면 조회x


    # 칼럼 이름만 따오려면?
    col_names = list(df_order.columns)
    # 따온 칼럼 이름으로 DataFrame 생성
    df_order_new = pd.DataFrame(col_names)
    # 한 줄로 병합
    df_order_new = pd.DataFrame(list(df_order.columns))


    result = pd.DataFrame(list(df_order.columns))
    for index, row in df_order.iterrows():
        print(row['CUST_ID'])
        print(row['PAY_METHOD'])





    print(a) # 디버깅용



if __name__ == '__main__':
    load_data()
