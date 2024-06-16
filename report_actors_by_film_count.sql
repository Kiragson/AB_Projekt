CREATE OR REPLACE PROCEDURE report_actors_by_film_count (
    p_result OUT VARCHAR2
) IS
    v_result_temp VARCHAR2(32767);
BEGIN
    -- Generowanie raportu
    FOR rec IN (
        SELECT a.AktorID, a.ImieNazwisko, COUNT(fa.FilmID) AS FilmCount
        FROM Aktorzy a
        JOIN FilmyAktorzy fa ON a.AktorID = fa.AktorID
        GROUP BY a.AktorID, a.ImieNazwisko
        ORDER BY FilmCount DESC
    ) LOOP
        v_result_temp := v_result_temp || 'AktorID: ' || rec.AktorID || ', ImieNazwisko: ' || rec.ImieNazwisko || ', FilmCount: ' || rec.FilmCount || '; ';
    END LOOP;

    -- Sprawdzenie, czy znaleziono jakiekolwiek wyniki
    IF v_result_temp IS NULL THEN
        p_result := 'Nie znaleziono aktorów w żadnych filmach.';
    ELSE
        p_result := v_result_temp;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'Nie znaleziono aktorów w żadnych filmach.';
    WHEN TOO_MANY_ROWS THEN
        p_result := 'Niespodziewana liczba zwróconych wierszy.';
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END report_actors_by_film_count;
/
