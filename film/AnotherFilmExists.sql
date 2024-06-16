CREATE OR REPLACE FUNCTION AnotherFilmExists(p_film_id IN NUMBER, p_tytul IN VARCHAR2) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Filmy WHERE LOWER(Tytul) = LOWER(p_tytul) AND FilmID != p_film_id;
    RETURN (v_count > 0);
END;
/
