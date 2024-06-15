CREATE OR REPLACE FUNCTION DeleteActorRoles(p_aktor_id IN NUMBER) RETURN NUMBER AS
BEGIN
    DELETE FROM FilmyAktorzy WHERE AktorID = p_aktor_id;
    RETURN SQL%ROWCOUNT; -- Zwraca liczbę usuniętych wierszy
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
