create or replace PROCEDURE report_films_by_year (
    p_year IN NUMBER,
    p_results OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_results FOR
        SELECT FilmID, Tytul, DataPremiery, Gatunek, Budzet, Przychody
        FROM Filmy
        WHERE EXTRACT(YEAR FROM DataPremiery) = p_year
        ORDER BY DataPremiery;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS FilmID, NULL AS Tytul, NULL AS DataPremiery, NULL AS Gatunek, NULL AS Budzet, NULL AS Przychody FROM dual WHERE 1 = 0;
END report_films_by_year;
/