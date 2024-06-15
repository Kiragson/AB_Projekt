CREATE OR REPLACE PROCEDURE wyszukaj_aktorow (
    p_partial_name IN VARCHAR2,
    p_results OUT SYS_REFCURSOR
) IS
BEGIN
    -- Otwarcie kursora z wynikami wyszukiwania
    OPEN p_results FOR
        SELECT AktorID, ImieNazwisko, DataUrodzenia, Plec
        FROM Aktorzy
        WHERE LOWER(ImieNazwisko) LIKE LOWER('%' || p_partial_name || '%');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS AktorID, NULL AS ImieNazwisko, NULL AS DataUrodzenia, NULL AS Plec FROM dual WHERE 1 = 0;
        RAISE;
END;
/
