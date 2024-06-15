CREATE OR REPLACE FUNCTION log_role_action (
    p_film_id IN NUMBER,
    p_actor_id IN NUMBER,
    p_action IN VARCHAR2,
    p_description IN VARCHAR2
) RETURN NUMBER AS
BEGIN
    INSERT INTO RoleLog (FilmID, ActorID, Action, Description)
    VALUES (p_film_id, p_actor_id, p_action, p_description);
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
