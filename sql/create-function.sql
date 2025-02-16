CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE OR REPLACE FUNCTION create_account(
    p_email TEXT,
    p_passwd TEXT,
    p_full_name TEXT
) RETURNS BOOLEAN AS $$
BEGIN
    INSERT INTO account (email, passwd, full_name)
    VALUES (p_email, crypt(p_passwd, gen_salt('bf')), p_full_name);
    RETURN TRUE;
EXCEPTION
    WHEN unique_violation THEN
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_account(
    p_email TEXT,
    p_passwd TEXT
) RETURNS TEXT AS $$
DECLARE
    v_full_name TEXT;
BEGIN
    SELECT full_name INTO v_full_name
    FROM account
    WHERE email = p_email AND passwd = crypt(p_passwd, passwd);
    
    RETURN v_full_name;
END;
$$ LANGUAGE plpgsql;


SELECT create_account('u.com', '1', 'John Doe');

SELECT check_account('user@example.com', 'mypassword');
