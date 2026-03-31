DROP PROCEDURE IF EXISTS upsert_contact;
CREATE OR REPLACE PROCEDURE upsert_contact(p_name VARCHAR, p_phone VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM contacts WHERE name = p_name) THEN
        UPDATE contacts SET phone = p_phone WHERE name = p_name;
    ELSE
        INSERT INTO contacts(name, phone) VALUES(p_name, p_phone);
    END IF;
END;
$$;

DROP PROCEDURE IF EXISTS delete_contact;
CREATE OR REPLACE PROCEDURE delete_contact(p_name VARCHAR, p_phone VARCHAR)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM contacts
    WHERE (p_name IS NOT NULL AND name = p_name)
       OR (p_phone IS NOT NULL AND phone = p_phone);
END;
$$;

DROP PROCEDURE IF EXISTS bulk_insert_contacts;
CREATE OR REPLACE PROCEDURE bulk_insert_contacts(p_names VARCHAR[], p_phones VARCHAR[])
LANGUAGE plpgsql AS $$
DECLARE
    i INT;
    invalid_data TEXT := '';
BEGIN
    FOR i IN array_lower(p_names,1)..array_upper(p_names,1) LOOP
        -- Проверка: телефон только цифры и длина 10-12
        IF p_phones[i] ~ '^[0-9]{10,12}$' THEN
            PERFORM upsert_contact(p_names[i], p_phones[i]);
        ELSE
            invalid_data := invalid_data || ' ' || p_names[i] || ':' || p_phones[i];
        END IF;
    END LOOP;
    
    IF invalid_data <> '' THEN
        RAISE NOTICE 'Некорректные данные:%', invalid_data;
    END IF;
END;
$$;