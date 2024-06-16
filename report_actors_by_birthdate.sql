CREATE OR REPLACE PROCEDURE report_actors_sorted_by_birthdate (
    p_result OUT VARCHAR2
) IS
    v_result_temp VARCHAR2(32767); -- Tymczasowy ciąg na wyniki
BEGIN
    -- Pobieranie wszystkich aktorów i sortowanie ich według daty urodzenia od najstarszego do najmłodszego
    FOR rec IN (
        SELECT AktorID, ImieNazwisko, DataUrodzenia, Plec
        FROM Aktorzy
        ORDER BY DataUrodzenia
    ) LOOP
        v_result_temp := v_result_temp || 'AktorID: ' || rec.AktorID || ', ImieNazwisko: ' || rec.ImieNazwisko ||
                         ', Data Urodzenia: ' || TO_CHAR(rec.DataUrodzenia, 'DD-MM-YYYY') || ', Płeć: ' || rec.Plec || '; ';
    END LOOP;

    IF v_result_temp IS NULL THEN
        p_result := 'Nie znaleziono aktorów.';
    ELSE
        p_result := v_result_temp;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END report_actors_sorted_by_birthdate;
/
