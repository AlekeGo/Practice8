DROP FUNCTION IF EXISTS get_contacts_by_pattern(text);
CREATE OR REPLACE FUNCTION get_contacts_by_pattern(p text)
RETURNS TABLE(name VARCHAR, phone VARCHAR) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.name, c.phone FROM contacts c
    WHERE c.name ILIKE '%' || p || '%'
       OR c.phone ILIKE '%' || p || '%';
END;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS get_contacts_paginated(int, int);
CREATE OR REPLACE FUNCTION get_contacts_paginated(p_limit int, p_offset int)
RETURNS TABLE(name VARCHAR, phone VARCHAR) AS $$
BEGIN
    RETURN QUERY 
    SELECT name, phone FROM contacts
    ORDER BY id
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;