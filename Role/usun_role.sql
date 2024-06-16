CREATE OR REPLACE PROCEDURE usun_role (
    p_film_id IN NUMBER,
    p_aktor_id IN NUMBER
) IS
    v_result NUMBER;
BEGIN
    -- Walidacja, czy film istnieje
    IF NOT FilmExists(p_film_id) THEN
        v_result := log_role_action(p_film_id, p_aktor_id, 'FAIL', 'Film o podanym ID nie istnieje.');
        RAISE_APPLICATION_ERROR(-20001, 'Film o podanym ID nie istnieje.');
    END IF;

    -- Walidacja, czy aktor istnieje
    IF NOT ActorExists(p_aktor_id) THEN
        v_result := log_role_action(p_film_id, p_aktor_id, 'FAIL', 'Aktor o podanym ID nie istnieje.');
        RAISE_APPLICATION_ERROR(-20002, 'Aktor o podanym ID nie istnieje.');
    END IF;

    -- Usunięcie roli
    DELETE FROM FilmyAktorzy WHERE FilmID = p_film_id AND AktorID = p_aktor_id;

    -- Logowanie udanego usunięcia roli
    v_result := log_role_action(p_film_id, p_aktor_id, 'SUCCESS', 'Rola została usunięta.');

    DBMS_OUTPUT.PUT_LINE('Rola została usunięta.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_role_action(p_film_id, p_aktor_id, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20003, 'Błąd podczas usuwania roli: ' || SQLERRM);
END usun_role;
/
