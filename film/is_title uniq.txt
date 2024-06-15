create or replace FUNCTION is_title_unique(p_tytul IN VARCHAR2) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Filmy WHERE LOWER(Tytul) = LOWER(p_tytul);
    RETURN (v_count = 0);
END;
/