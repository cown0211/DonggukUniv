from enum import Enum
from datetime import datetime
from abc import *         # 추상클래스 쓰기 위한 패키지



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
        self.first_name = f_name
        self.reg_date = None # no value == Null
        self.birth_date = None
        self.gender = None
        self.total_won = 0
        self.num_purchase = 0
        self.last_visited = None
        # self.id = 0 # 기본값을 그냥 0으로 두면 key가 죄다 0으로 일단 찍혀버림
        # 중복되면 안되는데 그걸 검수할 수가 없음! -> unique 값으로 배정되도록 해야함
        self.id = Customer.get_id(self)
        print('debug')

    def __str__(self):   # 클래스를 str으로 출력했을 때 표기되는 것 정의(오버라이딩)
        return '[' + str(self.id) + ']' + str(self.last_name) + ' ' + str(self.first_name)
        # 디버그 해보면 기존 메모리주소로 안나오고 성명으로 나옴

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

    def reset_record(self):
        self.num_purchase = 0
        self.total_won = 0
        self.last_visited = None
        return self



# Customer를 상속받은 Member 클래스 생성
class Member(Customer):
    # pass   # pass 문구는 조건없이 그대로 수용 => 요렇게만 쓰면 Customer랑 그냥 똑같음
    '''
    오버라이딩
    상속 받은 함수를 자기에게 최적화
    동물 클래스의 잠자기 -> 고양이 클래스의 나무 위에서 잠자기, 강아지 클래스의 바닥에서 잠자기
    '''
    # Member 클래스의 오버라이딩은 init
    def __init__(self,l_name:str,f_name:str,since): # 생성될 때의 자기 자신
        self.member_since = since

        # 이 밑의 것들은 어짜피 부모로부터 상속임, 줄줄이 쓸 이유 없음
        '''
        self.last_name = l_name
        self.first_name = f_name
        self.reg_date = None # no value == Null
        self.birth_date = None
        self.gender = None
        self.total_won = 0
        self.num_purchase = 0
        self.last_visited = None
        # self.id = 0 # 기본값을 그냥 0으로 두면 key가 죄다 0으로 일단 찍혀버림
        # 중복되면 안되는데 그걸 검수할 수가 없음! -> unique 값으로 배정되도록 해야함
        self.id = Customer.get_id(self)
        '''
        super().__init__(l_name, f_name)
        # 위 9줄 내용 한큐에 정리
        # 위 ''' '''처럼 쓰면 부모 클래스에서 변경 있으면 일일이 자식 클래스도 수정해줘야 함

    def consume(self,target_item: Item, qty, date):
        self.num_purchase += 1
        discount_rate = self.get_discount_rate()  # 회원 할인 적용
        self.total_won += target_item.price * qty * (1-discount_rate)
        print('Membership Discount - ' + str(self) + ' gets ' + str(100*(discount_rate)) + '%')
        # 콘솔창에서 확인 가능
        self.last_visited = date
        target_item.retrieve(qty, date)

    def get_discount_rate(self):  # 멤버 가입 후 90일 경과해야 할인 적용키로 함
        time_now = datetime.now()
        time_diff = time_now - self.member_since
        if time_diff.days > 90:
            return 0.05
        else:
            return 0.01



############# 추상 클래스 ###############
class ItemBase(metaclass=ABCMeta):  # 추상 클래스 문법 그 자체임 ABCMeta = Abstract Base Class Meta
    @abstractmethod
    def retrieve(self):
        pass

    @abstractmethod
    def get_stock(self):
        print('Retrieved!')



##########33333############
class Item_New(ItemBase):
    # pass # 만약 pass만 하면 에러 그대로 남, 오버라이딩이 필요!!
    def retrieve(self):
        print('[New] Retrieved!')
    # 여기까지만 하면 get_stock은 오버라이딩 안했으므로 에러
    def get_stock(self):
        pass