CREATE OR REPLACE FUNCTION FilmExists(p_film_id NUMBER) RETURN BOOLEAN IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM Filmy WHERE FilmID = p_film_id;
    RETURN (v_count > 0);
END;
/
