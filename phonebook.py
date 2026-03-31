from connect import get_connection

def search_contacts(pattern):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM get_contacts_by_pattern(%s)", (pattern,))
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows

def add_or_update_contact(name, phone):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("CALL upsert_contact(%s, %s)", (name, phone))
    conn.commit()
    cur.close()
    conn.close()

def delete_contact(name=None, phone=None):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("CALL delete_contact(%s, %s)", (name, phone))
    conn.commit()
    cur.close()
    conn.close()

def bulk_insert(names, phones):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("CALL bulk_insert_contacts(%s, %s)", (names, phones))
    conn.commit()
    cur.close()
    conn.close()

def get_paginated(limit, offset):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM get_contacts_paginated(%s, %s)", (limit, offset))
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return rows

if __name__ == "__main__":
    add_or_update_contact("Ali", "87001234567")
    add_or_update_contact("Sara", "87007654321")
    print(search_contacts("Ali"))
    print(get_paginated(2,0))
    bulk_insert(["John","Mike"], ["87009876543","12345abc"]) 