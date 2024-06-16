create or replace FUNCTION nazwa_filmu (
    p_film_id IN Filmy.FilmID%TYPE
) RETURN VARCHAR2 IS
    v_nazwa_filmu Filmy.Tytul%TYPE;
BEGIN
    SELECT Tytul INTO v_nazwa_filmu
    FROM Filmy
    WHERE FilmID = p_film_id;

    RETURN v_nazwa_filmu;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- Zwraca NULL, jeśli nie znaleziono filmu o podanym ID
    WHEN OTHERS THEN
        RAISE; -- Przekazuje inne wyjątki do wyższego poziomu
END nazwa_filmu;
/