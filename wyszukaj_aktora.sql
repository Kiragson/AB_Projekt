CREATE OR REPLACE PROCEDURE wyszukaj_aktorow (
    p_partial_name IN VARCHAR2,
    p_result OUT VARCHAR2
) IS
    v_aktorid NUMBER;
    v_imienazwisko VARCHAR2(255);
BEGIN
    -- Przykładowe zapytanie, które zwraca jednego aktora
    SELECT AktorID, ImieNazwisko INTO v_aktorid, v_imienazwisko
    FROM Aktorzy
    WHERE LOWER(ImieNazwisko) LIKE LOWER('%' || p_partial_name || '%') AND ROWNUM = 1;

    p_result := 'AktorID: ' || TO_CHAR(v_aktorid) || ', Imię i nazwisko: ' || v_imienazwisko;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'Nie znaleziono aktora.';
    WHEN OTHERS THEN
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END;
/
