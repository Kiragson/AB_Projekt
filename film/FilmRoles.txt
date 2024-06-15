CREATE OR REPLACE FUNCTION DeleteFilmRoles(p_film_id IN NUMBER) RETURN NUMBER AS
BEGIN
    DELETE FROM FilmyAktorzy WHERE FilmID = p_film_id;
    RETURN SQL%ROWCOUNT; -- Zwraca liczbę usuniętych wierszy
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
