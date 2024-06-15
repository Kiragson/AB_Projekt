CREATE OR REPLACE PROCEDURE usun_aktora (
    p_aktor_id IN NUMBER
) IS
    v_result NUMBER;
BEGIN
    -- Walidacja, czy aktor istnieje
    IF NOT ActorExists(p_aktor_id) THEN
        v_result := log_actor_action(p_aktor_id, 'FAIL', 'Aktor o podanym ID nie istnieje.');
        RAISE_APPLICATION_ERROR(-20001, 'Aktor o podanym ID nie istnieje.');
    END IF;

    -- Usunięcie powiązanych ról z tabeli FilmyAktorzy
    v_result := DeleteActorRoles(p_aktor_id);
    IF v_result = -1 THEN
        v_result := log_actor_action(p_aktor_id, 'ERROR', 'Błąd podczas usuwania ról aktora.');
        RAISE_APPLICATION_ERROR(-20002, 'Błąd podczas usuwania ról aktora.');
    END IF;

    -- Usunięcie aktora
    DELETE FROM Aktorzy WHERE AktorID = p_aktor_id;

    -- Logowanie udanego usunięcia aktora
    v_result := log_actor_action(p_aktor_id, 'SUCCESS', 'Aktor i powiązane role zostały usunięte.');

    DBMS_OUTPUT.PUT_LINE('Aktor i powiązane role zostały usunięte.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_actor_action(p_aktor_id, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20003, 'Błąd podczas usuwania aktora: ' || SQLERRM);
END usun_aktora;
/
