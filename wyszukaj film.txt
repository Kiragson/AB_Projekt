CREATE OR REPLACE PROCEDURE wyszukaj_filmy (
    p_partial_title IN VARCHAR2,
    p_results OUT SYS_REFCURSOR
) IS
BEGIN
    -- Otwarcie kursora z wynikami wyszukiwania
    OPEN p_results FOR
        SELECT FilmID, Tytul, DataPremiery, Gatunek, Opis, Budzet, Przychody
        FROM Filmy
        WHERE LOWER(Tytul) LIKE LOWER('%' || p_partial_title || '%');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS DataPremiery, NULL AS Gatunek, NULL AS Opis, NULL AS Budzet, NULL AS Przychody FROM dual WHERE 1 = 0;
        RAISE;
END;
/
