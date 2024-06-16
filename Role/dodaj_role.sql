CREATE OR REPLACE PROCEDURE dodaj_role (
    p_film_id IN NUMBER,
    p_aktor_id IN NUMBER,
    p_rola IN VARCHAR2
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

    -- Dodanie roli
    INSERT INTO FilmyAktorzy (FilmID, AktorID, Rola)
    VALUES (p_film_id, p_aktor_id, p_rola);

    -- Logowanie udanego dodania roli
    v_result := log_role_action(p_film_id, p_aktor_id, 'SUCCESS', 'Rola została dodana.');

    DBMS_OUTPUT.PUT_LINE('Rola została dodana.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_role_action(p_film_id, p_aktor_id, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20003, 'Błąd podczas dodawania roli: ' || SQLERRM);
END dodaj_role;
/
