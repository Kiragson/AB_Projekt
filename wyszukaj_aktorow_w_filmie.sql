CREATE OR REPLACE PROCEDURE wyszukaj_aktorow_w_filmie (
    p_nazwa_filmu IN VARCHAR2,
    p_result OUT VARCHAR2
) IS
    v_film_id NUMBER;
BEGIN
    -- Uzyskanie ID filmu na podstawie jego nazwy
    IF filmExists(p_nazwa_filmu) THEN
        SELECT get_film_id(p_nazwa_filmu) INTO v_film_id FROM dual;

        -- Otwarcie kursora z informacjami o aktorach i ich rolach w filmie
        FOR rec IN (SELECT a.AktorID, a.ImieNazwisko, fa.Rola
                    FROM Aktorzy a
                    JOIN FilmyAktorzy fa ON a.AktorID = fa.AktorID
                    WHERE fa.FilmID = v_film_id)
        LOOP
            p_result := p_result || 'AktorID: ' || rec.AktorID || ', ImieNazwisko: ' || rec.ImieNazwisko || ', Rola: ' || rec.Rola || '; ';
        END LOOP;

        IF p_result IS NULL THEN
            p_result := 'Brak aktorów dla tego filmu.';
        END IF;
    ELSE
        p_result := 'Nie znaleziono filmu o nazwie: ' || p_nazwa_filmu;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END;
