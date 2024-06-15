create or replace PROCEDURE report_actors_by_birthdate (
    p_birthdate IN DATE,
    p_before IN BOOLEAN,
    p_results OUT SYS_REFCURSOR
) IS
BEGIN
    IF p_before THEN
        OPEN p_results FOR
            SELECT AktorID, ImieNazwisko, DataUrodzenia, Plec
            FROM Aktorzy
            WHERE DataUrodzenia < p_birthdate
            ORDER BY DataUrodzenia;
    ELSE
        OPEN p_results FOR
            SELECT AktorID, ImieNazwisko, DataUrodzenia, Plec
            FROM Aktorzy
            WHERE DataUrodzenia >= p_birthdate
            ORDER BY DataUrodzenia;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS AktorID, NULL AS ImieNazwisko, NULL AS DataUrodzenia, NULL AS Plec FROM dual WHERE 1 = 0;
END report_actors_by_birthdate;
/