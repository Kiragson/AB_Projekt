CREATE OR REPLACE PROCEDURE wyszukaj_role_aktora (
    p_imie_nazwisko IN VARCHAR2,
    p_result OUT VARCHAR2
) IS
    c_aktor SYS_REFCURSOR;
    v_aktor_id NUMBER;
    v_result_temp VARCHAR2(32767); -- Tymczasowy ciąg na wyniki
BEGIN
    -- Uzyskanie kursora z ID aktorów na podstawie imienia i nazwiska
    c_aktor := id_aktor(p_imie_nazwisko);

    LOOP
        FETCH c_aktor INTO v_aktor_id;
        EXIT WHEN c_aktor%NOTFOUND;

        -- Pobieranie informacji o rolach aktora i dodawanie do wyniku
        FOR rec IN (
            SELECT f.FilmID, f.Tytul, fa.Rola
            FROM Filmy f
            JOIN FilmyAktorzy fa ON f.FilmID = fa.FilmID
            WHERE fa.AktorID = v_aktor_id
        ) LOOP
            v_result_temp := v_result_temp || 'FilmID: ' || rec.FilmID || ', Tytul: ' || rec.Tytul || ', Rola: ' || rec.Rola || '; ';
        END LOOP;
    END LOOP;

    CLOSE c_aktor;

    IF v_result_temp IS NULL THEN
        p_result := 'Nie znaleziono ról dla aktora o imieniu i nazwisku: ' || p_imie_nazwisko;
    ELSE
        p_result := v_result_temp;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'Nie znaleziono aktora o imieniu i nazwisku: ' || p_imie_nazwisko;
    WHEN OTHERS THEN
        IF c_aktor%ISOPEN THEN
            CLOSE c_aktor;
        END IF;
        p_result := 'Wystąpił błąd: ' || SQLERRM;
END;
/
