import dash
from dash import dcc, html
from dash.dependencies import Input, Output, State
from datetime import datetime
import matplotlib.pyplot as plt
import plotly.graph_objs as go
import plotly.express as px
import statsmodels.api as sm
import pandas as pd
import numpy as np

from db.conn import db  # Подключение к базе данных
from db.data import get_data_from_db
from db.login import get_user_credentials
from models.ols_coef import OLS_coef

app = dash.Dash(__name__, external_stylesheets=["/css/main.css"])

# Определите макеты для разных страниц
login_layout = html.Div(
    [
        dcc.Location(id="url"),
        html.H1("Форма входа"),
        html.Label("Имя пользователя"),
        dcc.Input(id="username-input", type="text"),
        html.Label("Пароль"),
        dcc.Input(id="password-input", type="password"),
        html.Button("Войти", id="login-button"),
        html.Div(id="login-status"),
        html.Div(id="page-content"),  # Добавляем элемент с id "page-content"
    ],
)
# начальный макет
app.layout = html.Div([login_layout])


# Обратный вызов
@app.callback(
    Output("url", "pathname"),
    Output("page-content", "children"),
    Output("login-status", "children"),
    Input("login-button", "n_clicks"),
    [
        State("username-input", "value"),
        State("password-input", "value"),
    ],
    prevent_initial_call=True,  # Предотвращаем вызов при загрузке страницы
)
def login_redirect(n_clicks, username, password):
    if n_clicks is not None:
        # Получить логин и пароль из базы данных для пользователя с id=1
        user_id = 1
        db_login, db_password = get_user_credentials(user_id)

        # Проверить введенные данные с данными из базы данных
        if username == db_login and password == db_password:
            app.layout = admin_layout
            return "/admin", admin_layout, "Вы успешно вошли как админ!"
        else:
            error_message = "Неверный логин или пароль. Попробуйте снова."
            return "/", html.Div()
    return "/", login_layout, ""


# работа с данными

# компоненты DatePickerRange для выбора дат
date_picker_range = dcc.DatePickerRange(
    id="date-range",
    start_date="2023-01-01",  #  начальная дата по умолчанию
    end_date="2023-12-31",  # конечная дата по умолчанию
    display_format="YYYY-MM-DD",  # Формат отображения дат
)


# Обратный вызов для обновления данных на основе выбранных дат
@app.callback(
    Output("data-table", "children"),
    Output("coefficients", "children"),
    Output("price-graph", "children"),
    Input("date-range", "start_date"),
    Input("date-range", "end_date"),
)
def update_data_table(start_date, end_date):
    start_date = datetime.strptime(start_date, "%Y-%m-%d").date()
    end_date = datetime.strptime(end_date, "%Y-%m-%d").date()

    # данные из базы данных на основе выбранных дат (start_date и end_date)
    data = get_data_from_db(start_date, end_date)

    # макет для отображения данных в виде таблицы
    data_table = html.Table(
        # Заголовки таблицы
        [
            html.Tr(
                [
                    html.Th("Уровень квалификации врача"),
                    html.Th("Тип услуги"),
                    html.Th("Возраст пациента"),
                    html.Th("Стаж работы врача (месяцы)"),
                    html.Th("Цена (в рублях)"),
                ]
            )
        ]
        +
        # Данные таблицы
        [
            html.Tr(
                [
                    html.Td(data_row[0]),
                    html.Td(data_row[1]),
                    html.Td(data_row[2]),
                    html.Td(data_row[3]),
                    html.Td(data_row[4]),
                ]
            )
            for data_row in data
        ]
    )

    # коэффициенты
    coefficients, residuals = OLS_coef(start_date, end_date)

    # элемент с коэффициентами
    coefficients_div = html.Div(
        [html.H3("Коэффициенты регрессии:"), html.Pre(str(coefficients))]
    )

    # полученные данные в DataFrame
    columns = [
        "Уровень квалификации врача",
        "Тип услуги",
        "Возраст пациента",
        "Стаж работы врача (месяцы)",
        "Цена (в рублях)",
    ]
    df = pd.DataFrame(data, columns=columns)

    df["Идентификатор услуги"] = df["Тип услуги"].astype("category").cat.codes
    # id услуг
    service_ids = df["Идентификатор услуги"].unique()
    alpha = 0.05  # ур. доверия
    figs = []

    for service_id in service_ids:
        service_data = df[df["Идентификатор услуги"] == service_id]
        X_service = service_data[
            [
                "Уровень квалификации врача",
                "Возраст пациента",
                "Стаж работы врача (месяцы)",
            ]
        ]
        X_service = sm.add_constant(X_service)
        y_service = service_data["Цена (в рублях)"]
        model_service = sm.OLS(y_service, X_service).fit()

        results = model_service.get_prediction(X_service)
        predictions = results.predicted_mean
        conf_int = results.conf_int(alpha=alpha)

        actual_prices = y_service.values

        # not range
        x_values = np.arange(len(predictions))

        fig = px.line(
            x=x_values,
            y=predictions,
            labels={"x": "Конкретный случай", "y": "Цена (в рублях)"},
            title=f"Доверительный интервал цен на услугу. Номер: {service_id}",
        )
        fig.add_trace(
            go.Scatter(
                x=x_values,
                y=actual_prices,
                mode="lines",
                name="Фактические значения",
                line=dict(color="red", dash="dash"),
            )
        )
        fig.add_trace(
            go.Scatter(
                x=x_values,
                y=predictions,
                mode="lines",
                name="Ожидаемые значения",
                line=dict(color="blue"),
            )
        )
        fig.add_trace(
            go.Scatter(
                x=x_values,
                y=conf_int[:, 0],
                fill="tozeroy",
                fillcolor="rgba(0,100,80,0.2)",
                line=dict(color="rgba(255,255,255,0)", width=0),
                name="Доверительный интервал (нижняя граница)",
            )
        )
        fig.add_trace(
            go.Scatter(
                x=x_values,
                y=conf_int[:, 1],
                fill="tonexty",
                fillcolor="rgba(0,100,80,0.2)",
                line=dict(color="rgba(255,255,255,0)", width=0),
                name="Доверительный интервал (верхняя граница)",
            )
        )

        figs.append(dcc.Graph(figure=fig))

    return data_table, coefficients_div, figs


# CSS стили для области с прокруткой
scrolling_div_style = {
    "width": "100%",
    "height": "320px",
    "overflowY": "scroll",  # вертикальная прокрутка
}


# admin_layout
admin_layout = html.Div(
    [
        html.H2("Административная панель"),
        date_picker_range,  # компоненты выбора дат
        html.Div(id="data-table", style=scrolling_div_style),
        html.Div(
            id="coefficients",
            style={
                "background-color": "white",
                "color": "red",
                "padding": "10px",
                "border": "1px solid #ccc",
                "border-radius": "5px",
                "margin-top": "10px",
            },
        ),
        # div для графиков
        html.Div(
            id="price-graph",
            style=scrolling_div_style,
        ),
    ],
)


if __name__ == "__main__":
    app.run_server(debug=True)
