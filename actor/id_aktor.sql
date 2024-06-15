create or replace FUNCTION id_aktor (
    p_imie_nazwisko IN VARCHAR2
) RETURN SYS_REFCURSOR IS
    c_aktor SYS_REFCURSOR;
BEGIN
    OPEN c_aktor FOR
        SELECT AktorID
        FROM Aktorzy
        WHERE LOWER(ImieNazwisko) LIKE LOWER('%' || p_imie_nazwisko || '%');
    RETURN c_aktor;
END id_aktor;
/