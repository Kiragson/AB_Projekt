CREATE OR REPLACE PROCEDURE dodaj_aktora (
    p_imie_nazwisko IN VARCHAR2,
    p_data_urodzenia IN DATE,
    p_plec IN VARCHAR2
) IS
    v_aktor_id NUMBER;
    v_result NUMBER;
BEGIN
    -- Sprawdzanie, czy aktor już istnieje
    IF ActorExists(p_imie_nazwisko) THEN
        v_result := log_actor_action(NULL, 'FAIL', 'Aktor o takim imieniu i nazwisku już istnieje.');
        RAISE_APPLICATION_ERROR(-20001, 'Aktor o takim imieniu i nazwisku już istnieje.');
    END IF;

    -- Generowanie nowego ID dla aktora
    SELECT aktor_id_seq.NEXTVAL INTO v_aktor_id FROM dual;

    -- Wstawianie nowego rekordu do tabeli Aktorzy
    INSERT INTO Aktorzy (AktorID, ImieNazwisko, DataUrodzenia, Plec)
    VALUES (v_aktor_id, p_imie_nazwisko, p_data_urodzenia, p_plec);

    -- Logowanie udanego dodania aktora
    v_result := log_actor_action(v_aktor_id, 'SUCCESS', 'Aktor został dodany.');

    DBMS_OUTPUT.PUT_LINE('Aktor został dodany. ID aktora: ' || v_aktor_id);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_actor_action(NULL, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20002, 'Błąd podczas dodawania aktora: ' || SQLERRM);
END dodaj_aktora;
/
