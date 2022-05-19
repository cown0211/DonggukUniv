# dash 패키지 설치
import dash # 서버와 관련
import dash_html_components as html
# ㄴ이걸 해줘야 html 코드를 쓸 수 있음
from dash.dependencies import Output, Input
import dash_core_components as dcc
import pandas as pd
import plotly.express as px # 차트 그리는 모듈 불러오기



'''연습!
app = dash.Dash(__name__)
app.layout = html.Div([html.Button('Click Me!',id='button1',style={'display':'block'})])
# ㄴHTML 버튼 코드를 레이아웃에 삽입     버튼 캡션    버튼 아이디    버튼 스타일(딕셔너리형식)
## 우하단에 뜨는 것은 디버깅모드로 s해둬서 뜨는 것 app.run_server(debug=True)



@app.callback(Output(component_id='button1',component_property='children'),
              [Input(component_id='button1',component_property='n_clicks')])
# @ decorator, 중간 함수 앞뒤를 감싸준다


def num_push_button(input_value): # 받은 값을 그대로 반환
    if input_value == None:
        return 'Start Now'
    else:
        return input_value

연습끝!'''



app = dash.Dash(__name__)


df_order = pd.read_excel('DB_Structure.xlsx',sheet_name='ORDER')
df_customer = pd.read_excel('DB_Structure.xlsx',sheet_name='CUSTOMER')
df_stock = pd.read_excel('DB_Structure.xlsx', sheet_name='STOCK')


app.layout = html.Div(
    [
        html.H1('Perfume Sales DashBoard for ISE4032',style={'text-align':'center','font-family':'consolas'}),
        # .H1()은 글자 크기! 제일 큰것, H2,3,4~~~도 있음              중앙정렬             폰트는 콘솔라스
        # ㄴ타이틀
        dcc.Dropdown(
            id='select_option',
            options=[
                {'label':'Entry','value':'ENTRY'},
                {'label':'Premium','value':'PREMIUM'},
                {'label':'High End','value':'HIGH END'},
                {'label':'All Products','value':'ALL'}
            ],
            multi=False,   # 다중선택 불가!
            value='ALL',    # 기본값 ALL로 설정 , 여기까지만 하면 넙대대...
            style={'width':'40%','font-family':'consolas'}
        ),
        html.Div(id='output_container',children=[],style={'font-family':'consolas'}),
        # ㄴ차트에 대한 옵션
        html.Br(),  # 줄바꿈
        dcc.Graph(id='sales_info',figure={}) # 차트그려줌
    ]

)



@app.callback( # 콜백함수를 이용하여 원하는 옵션에 맞게 생성된 차트를 다시 레이아웃으로 반환
    [
        Output(component_id='output_container',component_property='children'),
        Output(component_id='sales_info',component_property='figure')

    ],
    [Input(component_id='select_option',component_property='value')]
)



def update_graph(option_selected):   # 선택된 옵션대로 차트 업데이트 위함!
    container = 'Selected Category: {}'.format(option_selected) # 선택된

    if option_selected == 'ALL':
        df_new = df_stock.set_index('ITEM_ID').join(df_order.set_index('ITEM_ID'))
        df_new['TOTAL_PRICE'] = df_new['PRICE'] * df_new['ITEM_QTY']
    else:
        df_new = df_stock.set_index('ITEM_ID').join(df_order.set_index('ITEM_ID'))
        df_new['TOTAL_PRICE'] = df_new['PRICE'] * df_new['ITEM_QTY']
        df_new = df_new.loc[df_new['ITEM_NAME'] == option_selected]  # 원하는 ITEM만 가져옴

    fig = px.line(df_new, x='ORDER_DATE', y='TOTAL_PRICE', color='ITEM_NAME',
                     hover_name='ITEM_NAME', hover_data=['QTY','PAY_METHOD'])
    fig.update_traces(mode="markers+lines")

    return container, fig   ## 여기까지가 콜백함수, 아웃풋 2개! 인풋1개!




if __name__ == "__main__":
    app.run_server(debug=True)
    # Dash is running on ~~ 클릭하면 난리남
