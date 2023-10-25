from db.conn import db
from collections import namedtuple


def get_data_from_db(start_date, end_date):
    query = """
    SELECT
        Doctor.qualification AS "Уровень квалификации врача",
        Service.name AS "Тип услуги",
        Client.age AS "Возраст пациента",
        Doctor.seniority AS "Стаж работы врача (месяцы)",
        provided_service.price AS "Цена (в рублях)"
    FROM
        provided_service
        JOIN Doctor ON provided_service.id_doctor = Doctor.id
        JOIN Client ON provided_service.id_client = Client.id
        JOIN Service ON provided_service.id_service = Service.id
    WHERE
        provided_service.datetime >= %s AND provided_service.datetime <= %s
    """
    with db.cursor() as cursor:
        cursor.execute(query, (start_date, end_date))
        data = cursor.fetchall()
    return data
