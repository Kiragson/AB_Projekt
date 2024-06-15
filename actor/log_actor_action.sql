CREATE OR REPLACE FUNCTION log_actor_action (
    p_aktor_id IN NUMBER,
    p_action IN VARCHAR2,
    p_description IN VARCHAR2
) RETURN NUMBER AS
BEGIN
    INSERT INTO ActorLog (ActorID, Action, Description)
    VALUES (p_aktor_id, p_action, p_description);
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END;
/
