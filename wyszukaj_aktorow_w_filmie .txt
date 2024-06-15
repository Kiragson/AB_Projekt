CREATE OR REPLACE PROCEDURE wyszukaj_aktorow_w_filmie (
    p_nazwa_filmu IN VARCHAR2,
    p_results OUT SYS_REFCURSOR
) IS
    v_film_id NUMBER;
BEGIN
    -- Uzyskanie ID filmu na podstawie jego nazwy
    SELECT get_film_id(p_nazwa_filmu) INTO v_film_id FROM dual;

    -- Sprawdzenie, czy film istnieje
    IF v_film_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono filmu o nazwie: ' || p_nazwa_filmu);
        OPEN p_results FOR SELECT NULL AS AktorID, NULL AS ImieNazwisko, NULL AS Rola FROM dual WHERE 1 = 0;
        RETURN;
    END IF;

    -- Otwarcie kursora z informacjami o aktorach i ich rolach w filmie
    OPEN p_results FOR
        SELECT a.AktorID, a.ImieNazwisko, fa.Rola
        FROM Aktorzy a
        JOIN FilmyAktorzy fa ON a.AktorID = fa.AktorID
        WHERE fa.FilmID = v_film_id;

    -- Sprawdzenie, czy kursor zawiera jakiekolwiek wiersze
    IF p_results%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak aktorów dla tego filmu.');
        CLOSE p_results;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono filmu o nazwie: ' || p_nazwa_filmu);
        OPEN p_results FOR SELECT NULL AS AktorID, NULL AS ImieNazwisko, NULL AS Rola FROM dual WHERE 1 = 0;
    WHEN OTHERS THEN
        IF p_results%ISOPEN THEN
            CLOSE p_results;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        RAISE;
END;
/
