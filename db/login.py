from db.conn import db


def get_user_credentials(user_id):
    cursor = db.cursor()
    query = f"SELECT login, password FROM account WHERE id = {user_id}"
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    return result  # Вернуть кортеж (login, password)
