create or replace FUNCTION ActorExists(p_imie_nazwisko VARCHAR2) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Aktorzy WHERE LOWER(ImieNazwisko) = LOWER(p_imie_nazwisko);
    RETURN (v_count > 0);
END;
/