from enum import Enum



class Item:
    def __init__(self, id: int):
        self.id = id
        self.type = -1
        self.price = 1000
        self.quantity = 1000
        self.last_updated = None
        self.replenished = 0

    def retrieve(self, qty, date):
        self.last_updated = date
        self.quantity -= qty  # 이대로 두면 수량 음수 될 수도 있음
        if self.quantity < 10:
            self.quantity = 50 # quantity 10 미만 되면 50으로 리필해주는 개념
            self.replenished += 1


class Item_Type(Enum):
    ENTRY = 1
    PREMIUM = 2
    HIGH_END = 3
    NOT_ASSIGNED = None


class Customer:
    ID_Cnt = 0 # (3) 클래스변수, Customer 클래스에 속한 함수 shared!

    # store_name = "ISE_4032"  # 여기에서 설정 해줘도 210507/26에서 변경하면 모든 cust에게 적용됨

    def __init__(self,l_name:str,f_name:str): # 생성될 때의 자기 자신
        self.last_name = l_name # (1) 클래스 각각에 소속된 전역변수
        # last_name_local = 'none' # (2) 클래스에 소속되지 않는 지역변수
        # (2)를 쓴다면 다른 데에서 클래스를 불러올 때 못불러오고 날라감
        # (1)를 써줘야 클래스를 다른 데에서 가져와도 변수가 살아있음
        # (1),(2)는 인스턴스변수, (3) 클래스변수
        self.first_neme = f_name
        self.reg_date = None # no value == Null
        self.birth_date = None
        self.gender = None
        self.total_won = 0
        self.num_purchase = 0
        self.member = False
        self.last_visited = None
        # self.id = 0 # 기본값을 그냥 0으로 두면 key가 죄다 0으로 일단 찍혀버림
        # 중복되면 안되는데 그걸 검수할 수가 없음! -> unique 값으로 배정되도록 해야함
        self.id = Customer.get_id(self)
        print('debug')

    '''
    def __init__(self,prev_id):
        ~~~
        prev_id += prev_id
        self.id = prev_id
    ㄴ 이렇게 코드 넣으면 메인코드에서 
    cust_1 = ise.Customer(prev_id=0)
    cust_2 = ise.Customer(prev_id=cust_1.id)
    ㄴ 이렇게 넣어줘야 하는데 prev_id 값의 중복을 일일이 확인하기 어려움
    그래서 해당 코드는 x
    '''


    def get_id(self):
        Customer.ID_Cnt += 1
        return Customer.ID_Cnt
    # ID를 자동으로 1부터 +1 씩 시켜주는 함수


    def consume(self, target_item: Item, qty, date):
        self.num_purchase += 1
        self.total_won += target_item.price * qty
        self.last_visited = date
        target_item.retrieve(qty, date)