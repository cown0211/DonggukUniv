import pandas as pd
import math
from bs4 import BeautifulSoup # Ctrl + Space beautifulsoup 선택
from urllib.request import urlopen
# 패키지 beautifulsoup4, requests 설치
from datetime import date # 기본 패키지

def load_data():
    html = urlopen('https://sites.google.com/dgu.ac.kr/dguise4032/itemlist')
    # 웹페이지 전체 컨텐츠를 긁어옴
    bsObject = BeautifulSoup(html, 'html.parser')
    # HTML 파일을 불러와서 파싱(=변환)
    # Variables 중 text 가면 웹 페이지의 text 다 긁어옴
    print(bsObject.text)
    print(bsObject.getText())
    # 후자가 함수로 원하는 값 반환받기 용이

    # 긁어오긴 하는데 여기서 가격을 어떻게 추출하나?
    text = bsObject.getText()
    print(text.index('KRW')) # 텍스트 내의 특정 키워드 위치 반환

    # 특정 키워드를 다른 키워드로 대체하고 이 전후로 슬라이싱
    text = text.replace('KRW', '#') # KRW -> #으로 변환
    text = text.replace('ENTRY', '#')
    text = text.replace('PREMIUM', '#')
    text = text.replace('HIGH END', '#')

    prices = text.split('#') # '#'을 구분자 기준으로 텍스트 분할
    price_entry = int(prices[1])
    price_premium = int(prices[3])
    price_highend = int(prices[5])

    today = date.today()
    print(today.strftime('%d/%m/%Y'))
    # Y - 2021 / y - 21


    print('done')


if __name__ == '__main__':
    load_data()
