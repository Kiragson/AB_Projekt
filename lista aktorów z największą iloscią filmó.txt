create or replace PROCEDURE report_actors_by_film_count (
    p_results OUT SYS_REFCURSOR
) IS
BEGIN
    OPEN p_results FOR
        SELECT a.AktorID, a.ImieNazwisko, COUNT(fa.FilmID) AS FilmCount
        FROM Aktorzy a
        JOIN FilmyAktorzy fa ON a.AktorID = fa.AktorID
        GROUP BY a.AktorID, a.ImieNazwisko
        ORDER BY FilmCount DESC;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        OPEN p_results FOR SELECT NULL AS AktorID, NULL AS ImieNazwisko, NULL AS FilmCount FROM dual WHERE 1 = 0;
END report_actors_by_film_count;
/