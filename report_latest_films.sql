create or replace PROCEDURE report_latest_films (
    p_result OUT VARCHAR2
) IS
BEGIN
    p_result := '';

    FOR rec IN (
        SELECT FilmID, Tytul, DataPremiery, Gatunek, Budzet, Przychody
        FROM Filmy
        ORDER BY DataPremiery DESC
        FETCH FIRST 5 ROWS ONLY
    ) LOOP
        p_result := p_result || 'FilmID: ' || rec.FilmID || ', Tytul: ' || rec.Tytul || 
                     ', Data Premiery: ' || TO_CHAR(rec.DataPremiery, 'DD-MM-YYYY') || 
                     ', Gatunek: ' || rec.Gatunek || ', Budzet: ' || rec.Budzet || 
                     ', Przychody: ' || rec.Przychody || CHR(10);
    END LOOP;

    IF p_result IS NULL THEN
        p_result := 'Brak filmów.';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END report_latest_films;
/