CREATE OR REPLACE PROCEDURE wyszukaj_filmy_aktora (
    p_imie_nazwisko IN VARCHAR2,
    p_results OUT SYS_REFCURSOR
) IS
    v_aktor_id NUMBER;
BEGIN
    -- Sprawdzenie, czy aktor istnieje
    SELECT AktorID INTO v_aktor_id FROM Aktorzy WHERE LOWER(ImieNazwisko) = LOWER(p_imie_nazwisko);

    -- Otwarcie kursora dla wyników
    OPEN p_results FOR
        SELECT f.FilmID, nazwa_filmu(f.FilmID) AS Tytul, f.DataPremiery, f.Gatunek, f.Opis, f.Budzet, f.Przychody
        FROM Filmy f
        JOIN FilmyAktorzy fa ON f.FilmID = fa.FilmID
        WHERE fa.AktorID = v_aktor_id;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Brak filmów dla podanego aktora: ' || p_imie_nazwisko);
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS DataPremiery, NULL AS Gatunek, NULL AS Opis, NULL AS Budzet, NULL AS Przychody FROM DUAL WHERE 1 = 0;
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: Nieprawidłowy format danych. ID aktora nie jest liczbą.');
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS DataPremiery, NULL AS Gatunek, NULL AS Opis, NULL AS Budzet, NULL AS Przychody FROM DUAL WHERE 1 = 0;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS DataPremiery, NULL AS Gatunek, NULL AS Opis, NULL AS Budzet, NULL AS Przychody FROM DUAL WHERE 1 = 0;
END;
/
