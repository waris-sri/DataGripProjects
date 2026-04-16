# To start, run:
# python3 -m venv venv
# source venv/bin/activate
# pip install mysql-connector-python

import mysql.connector
from mysql.connector import MySQLConnection, Error
from configparser import ConfigParser


# ── Config reader ──────────────────────────────────────
def read_config(filename="app.ini", section="mysql"):
    config = ConfigParser()
    config.read(filename)

    data = {}
    if config.has_section(section):
        items = config.items(section)
        for item in items:
            data[item[0]] = item[1]
    else:
        raise Exception(f"{section} section not found in the {filename} file")
    return data


# ── Task 1: Query authors table ───────────────────────────────────────────────
def query_authors(config):
    try:
        conn = MySQLConnection(**config)
        cursor = conn.cursor()

        cursor.execute("SELECT * FROM AUTHORS")
        rows = cursor.fetchall()

        print("Total Row(s):", cursor.rowcount)
        for row in rows:
            print(row)

    except Error as e:
        print(e)
    finally:
        cursor.close()
        conn.close()


# ── Task 2a: Insert an author into authors table ──────────────────────────────
def insert_author(config, author_id, first_name, last_name):
    query = """INSERT INTO AUTHORS(id, first_name, last_name)
               VALUES (%s, %s, %s)"""
    args = (author_id, first_name, last_name)

    try:
        with MySQLConnection(**config) as conn:
            with conn.cursor() as cursor:
                cursor.execute(query, args)
            conn.commit()
    except Error as e:
        print(e)


# ── Task 2b: Show authors from a given id onward (to confirm insert) ──────────
def query_authors_tail(config, from_id=40):
    """Fetch rows with id >= from_id so the new entry is visible."""
    query = "SELECT * FROM AUTHORS WHERE id >= %s ORDER BY id"
    try:
        conn = MySQLConnection(**config)
        cursor = conn.cursor()

        cursor.execute(query, (from_id,))
        rows = cursor.fetchall()

        for row in rows:
            print(row)

    except Error as e:
        print(e)
    finally:
        cursor.close()
        conn.close()


# ── Main ──────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    config = read_config(filename="app.ini")

    # Task 1
    print("=== Task 1: Query authors ===")
    query_authors(config)

    # Task 2a – insert author matching the lab sheet example (id=100, ABC, DEF)
    print("\n=== Task 2a: Insert author (id=100, 'ABC', 'DEF') ===")
    insert_author(config, 100, "ABC", "DEF")

    # Task 2b – show tail of authors table to confirm insertion
    print("\n=== Task 2b: Show authors from id 40 onward ===")
    query_authors_tail(config, from_id=40)
