CREATE OR REPLACE PROCEDURE wyszukaj_filmy (
    p_partial_title IN VARCHAR2,
    p_result OUT VARCHAR2
) IS
    CURSOR film_cursor IS
        SELECT FilmID, Tytul, DataPremiery, Gatunek, Opis, Budzet, Przychody
        FROM Filmy
        WHERE LOWER(Tytul) LIKE LOWER('%' || p_partial_title || '%');
    v_film VARCHAR2(4000);
BEGIN
    FOR rec IN film_cursor LOOP
        v_film := v_film || 'FilmID: ' || TO_CHAR(rec.FilmID) || ', Tytul: ' || rec.Tytul || 
                  ', Data Premiery: ' || TO_CHAR(rec.DataPremiery, 'DD-MM-YYYY') || ', Gatunek: ' || rec.Gatunek || 
                  ', Opis: ' || SUBSTR(rec.Opis, 1, 50) || '..., Budzet: ' || TO_CHAR(rec.Budzet) || 
                  ', Przychody: ' || TO_CHAR(rec.Przychody) || '; ';
    END LOOP;

    IF v_film IS NULL THEN
        p_result := 'Nie znaleziono filmu.';
    ELSE
        p_result := v_film;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END;
/
