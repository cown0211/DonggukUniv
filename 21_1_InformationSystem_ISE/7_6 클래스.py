import pandas as pd

import ise4032_class_210604
import ise4032_class_210604 as ise




def load_data():

    returnFunction = ise4032_class_210604.function_test(1,2)
    # function에서 return 값이 없더라도 None으로 return을 함

    returnfunc = ise4032_class_210604.function_sum1(1,2,3,4)

    returnfunc2 = ise4032_class_210604.function_sum2(x=1, u=1)
    returnfunc2 = ise4032_class_210604.function_sum2(**{'x':1, 'u':1})


    ## 이 밑으로 노필요 ##
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



    # testItem = ise4032_class_210528.ItemBase() # 이렇게 하면 에러남 - 추상클래스를 실제로 상속받아 구현하지 않음
    # class 폴더 3333로 ㄱㄱ
    testItem = ise4032_class_210528.Item_New()



    '''
    for문 축약
    cust_num_purchase = []
    for cust in cust_list:
        cust_num_purchase.append(cust.num_purchase)
    3줄짜리를 밑의 한줄짜리로 축약 가능
    
    cust_num_purchase = [cust.num_purchase for cust in cust_list]
    '''


    # lambda - 함수형 프로그래밍! 위의 예시의 일반화 케이스

    # 돌고 있는 반복문의 index 알 수 있음
    for indx, obj in enumerate(cust_list):
        print(indx, obj)


    # filter
    filtertest = list(filter(lambda x: x.num_purchase > 0, cust_list))
    # cust_list에 있는 x(customer) 중에서 num_purchase가 0보다 큰 경우만 걸러냄

    # map
    maptest = list(map(lambda c: c.reset_record() if c.last_name == 'KIM' else c, cust_list))
    # cust_list를 c라는 변수로 돌림, c의 성이 김이면 reset_record를 반환, 아니면 c를 반환




    print('debug')

if __name__ == "__main__":
    load_data()
