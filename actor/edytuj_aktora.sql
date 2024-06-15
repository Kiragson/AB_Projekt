CREATE OR REPLACE PROCEDURE edytuj_aktora (
    p_aktor_id IN NUMBER,
    p_imie_nazwisko IN VARCHAR2,
    p_data_urodzenia IN DATE,
    p_plec IN VARCHAR2
) IS
    v_exists NUMBER;
    v_result NUMBER;
BEGIN
    -- Walidacja, czy aktor istnieje
    SELECT COUNT(1) INTO v_exists FROM Aktorzy WHERE AktorID = p_aktor_id;
    IF v_exists = 0 THEN
        v_result := log_actor_action(p_aktor_id, 'FAIL', 'Aktor o podanym ID nie istnieje.');
        RAISE_APPLICATION_ERROR(-20001, 'Aktor o podanym ID nie istnieje.');
    END IF;

    -- Sprawdzenie, czy istnieje inny aktor z takim samym imieniem i nazwiskiem
    IF AnotherActorExists(p_aktor_id, p_imie_nazwisko) THEN
        v_result := log_actor_action(p_aktor_id, 'FAIL', 'Inny aktor o takim samym imieniu i nazwisku już istnieje.');
        RAISE_APPLICATION_ERROR(-20002, 'Inny aktor o takim samym imieniu i nazwisku już istnieje.');
    END IF;

    -- Aktualizacja danych aktora
    UPDATE Aktorzy
    SET ImieNazwisko = p_imie_nazwisko,
        DataUrodzenia = p_data_urodzenia,
        Plec = p_plec
    WHERE AktorID = p_aktor_id;

    -- Logowanie udanej aktualizacji
    v_result := log_actor_action(p_aktor_id, 'SUCCESS', 'Dane aktora zaktualizowane.');

    DBMS_OUTPUT.PUT_LINE('Aktor został zaktualizowany.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_actor_action(p_aktor_id, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20003, 'Błąd podczas aktualizacji danych aktora: ' || SQLERRM);
END edytuj_aktora;
/
