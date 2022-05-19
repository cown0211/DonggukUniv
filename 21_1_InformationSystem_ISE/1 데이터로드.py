import pandas as pd
#pandas를 pd로 불러오기


def load_data(): #함수정의
    df_order = pd.read_excel('DB_Structure.xlsx',sheet_name='ORDER')
    df_customer = pd.read_excel('DB_Structure.xlsx',sheet_name='CUSTOMER')
    df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')


if __name__ == '__main__':
    load_data()
