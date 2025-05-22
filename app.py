import streamlit as st
import mysql.connector
from mysql.connector import Error
import pandas as pd

# ——— DB Connection with test ——————————————————————————————
@st.cache_resource
def get_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            user="notebook",           # your user
            password="Notebook123!",   # your password
            database="xyz_company"
        )
        return conn
    except Error as e:
        st.error(f"❌ Connection failed: {e}")
        st.stop()

# Establish and test connection
conn = get_connection()
test_cursor = conn.cursor()
try:
    test_cursor.execute("SELECT 1")
    _ = test_cursor.fetchall()  # consume result
    st.sidebar.success("✅ Connected to xyz_company")
finally:
    test_cursor.close()

# ——— Helpers to fetch metadata with fresh cursors —————————————
@st.cache_data
def get_tables():
    c = conn.cursor()
    c.execute("SHOW TABLES")
    tables = [row[0] for row in c.fetchall()]
    c.close()
    return tables

@st.cache_data
def get_table_info(table: str):
    c = conn.cursor()
    c.execute(f"SHOW COLUMNS FROM {table}")
    cols = c.fetchall()  # (Field, Type, Null, Key, Default, Extra)
    c.close()
    return [
        {
            "Field":   row[0],
            "Type":    row[1],
            "Null":    row[2],
            "Key":     row[3],
            "Default": row[4],
            "Extra":   row[5]
        }
        for row in cols
    ]

# ——— Sidebar UI ——————————————————————————————————————————
st.sidebar.title("XYZ Company CRUD")
table = st.sidebar.selectbox("Select Table", sorted(get_tables()))
op    = st.sidebar.radio("Operation", ["Create","Read","Update","Delete"])

st.title(f"{op} rows in `{table}`")
table_info = get_table_info(table)
cols = [col["Field"] for col in table_info]

# ——— CRUD Operations —————————————————————————————————————
if op == "Read":
    c = conn.cursor()
    c.execute(f"SELECT * FROM {table} LIMIT 100")
    rows = c.fetchall()
    c.close()
    df = pd.DataFrame(rows, columns=cols)
    st.dataframe(df)

elif op == "Create":
    st.write(f"Create rows in `{table}`")
    st.write("Fill in all fields below and click Submit")
    data = {}
    for col in table_info:
        if "auto_increment" in col["Extra"]:
            continue
        default = "" if col["Default"] is None else col["Default"]
        data[col["Field"]] = st.text_input(
            label=f'{col["Field"]} ({col["Type"]})',
            value=str(default)
        )
    if st.button("Submit"):
        keys = ", ".join(data.keys())
        vals = ", ".join(["%s"] * len(data))
        sql = f"INSERT INTO {table} ({keys}) VALUES ({vals})"
        try:
            c = conn.cursor()
            c.execute(sql, tuple(data.values()))
            conn.commit()
            st.success(f"Inserted row with ID {c.lastrowid}")
            c.close()
        except Error as e:
            st.error(f"Insert failed: {e}")

elif op == "Update":
    pk_field = cols[0]
    pk_value = st.text_input(f"Enter {pk_field} to identify row")
    st.write("Fill only the fields you want to change")
    updates = {}
    for col in cols[1:]:
        val = st.text_input(col)
        if val:
            updates[col] = val
    if st.button("Submit"):
        if not pk_value:
            st.warning("🔑 Enter the primary key first.")
        elif not updates:
            st.warning("🛑 Nothing to update.")
        else:
            set_clause = ", ".join(f"{k}=%s" for k in updates)
            sql = f"UPDATE {table} SET {set_clause} WHERE {pk_field}=%s"
            params = list(updates.values()) + [pk_value]
            try:
                c = conn.cursor()
                c.execute(sql, params)
                conn.commit()
                st.success(f"Updated row {pk_value}")
                c.close()
            except Error as e:
                st.error(f"Update failed: {e}")

elif op == "Delete":
    pk_field = cols[0]
    pk_value = st.text_input(f"Enter {pk_field} to delete")
    if st.button("Delete"):
        if not pk_value:
            st.warning("Please enter a primary key.")
        else:
            try:
                c = conn.cursor()
                c.execute(f"DELETE FROM {table} WHERE {pk_field}=%s", (pk_value,))
                conn.commit()
                st.success(f"Deleted row {pk_value}")
                c.close()
            except Error as e:
                st.error(f"Delete failed: {e}")