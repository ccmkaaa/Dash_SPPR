import pandas as pd
import numpy as np
import statsmodels.api as sm
from db.data import get_data_from_db


def OLS_coef(start_date, end_date):
    data = get_data_from_db(start_date, end_date)

    df = pd.DataFrame(
        data,
        columns=[
            "Уровень квалификации врача",
            "Тип услуги",
            "Возраст пациента",
            "Стаж работы врача (месяцы)",
            "Цена (в рублях)",
        ],
    )

    df["Идентификатор услуги"] = df["Тип услуги"].astype("category").cat.codes

    X = df[
        [
            "Уровень квалификации врача",
            "Идентификатор услуги",
            "Возраст пациента",
            "Стаж работы врача (месяцы)",
        ]
    ]
    y = df["Цена (в рублях)"]
    X = sm.add_constant(X)  # константа для β0

    model = sm.OLS(y, X).fit()

    coefficients = model.params
    eps = model.resid

    return coefficients, eps
