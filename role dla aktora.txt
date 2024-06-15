CREATE OR REPLACE PROCEDURE wyszukaj_role_aktora (
    p_imie_nazwisko IN VARCHAR2,
    p_results OUT SYS_REFCURSOR
) IS
    v_aktor_id NUMBER;
BEGIN
    -- Uzyskanie ID aktora na podstawie jego imienia i nazwiska
    SELECT AktorID INTO v_aktor_id FROM Aktorzy WHERE LOWER(ImieNazwisko) = LOWER(p_imie_nazwisko);

    -- Otwarcie kursora z informacjami o rolach aktora
    OPEN p_results FOR
        SELECT f.FilmID, f.Tytul, fa.Rola
        FROM Filmy f
        JOIN FilmyAktorzy fa ON f.FilmID = fa.FilmID
        WHERE fa.AktorID = v_aktor_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie znaleziono aktora o imieniu i nazwisku: ' || p_imie_nazwisko);
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS Rola FROM dual WHERE 1 = 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS Rola FROM dual WHERE 1 = 0;
        RAISE;
END;
/
