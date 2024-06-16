CREATE OR REPLACE FUNCTION get_film_id(p_nazwa_filmu VARCHAR2) RETURN NUMBER IS
    v_film_id NUMBER;
BEGIN
    SELECT FilmID INTO v_film_id FROM Filmy WHERE LOWER(Tytul) = LOWER(p_nazwa_filmu);
    RETURN v_film_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
