CREATE OR REPLACE PROCEDURE report_films_by_year (
    p_year IN NUMBER,
    p_result OUT VARCHAR2
) IS
    v_result_temp VARCHAR2(32767);
BEGIN
    -- Walidacja podanego roku
    IF p_year IS NULL OR p_year < 1000 OR p_year > 9999 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Podano nieprawidłowy rok. Rok musi być pomiędzy 1000 a 9999.');
    END IF;

    -- Generowanie raportu
    FOR rec IN (
        SELECT FilmID, Tytul, DataPremiery, Gatunek, Budzet, Przychody
        FROM Filmy
        WHERE EXTRACT(YEAR FROM DataPremiery) = p_year
        ORDER BY DataPremiery
    ) LOOP
        v_result_temp := v_result_temp || 'FilmID: ' || rec.FilmID || ', Tytul: ' || rec.Tytul || 
                         ', Data Premiery: ' || TO_CHAR(rec.DataPremiery, 'DD-MM-YYYY') || 
                         ', Gatunek: ' || rec.Gatunek || ', Budzet: ' || rec.Budzet || 
                         ', Przychody: ' || rec.Przychody || '; ';
    END LOOP;

    -- Sprawdzenie, czy znaleziono jakiekolwiek wyniki
    IF v_result_temp IS NULL THEN
        p_result := 'Nie znaleziono filmów dla podanego roku.';
    ELSE
        p_result := v_result_temp;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END report_films_by_year;
/
