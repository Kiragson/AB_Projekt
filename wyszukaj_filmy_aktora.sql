CREATE OR REPLACE PROCEDURE wyszukaj_filmy_aktora (
    p_imie_nazwisko IN VARCHAR2,
    p_result OUT VARCHAR2
) IS
    v_aktor_id NUMBER;
    v_result_temp VARCHAR2(32000); -- tymczasowy ciąg na wyniki
BEGIN
    -- Sprawdzenie, czy aktor istnieje
    SELECT AktorID INTO v_aktor_id FROM Aktorzy WHERE LOWER(ImieNazwisko) = LOWER(p_imie_nazwisko);

    FOR rec IN (SELECT f.FilmID, nazwa_filmu(f.FilmID) AS Tytul, f.DataPremiery, f.Gatunek, f.Opis, f.Budzet, f.Przychody
                FROM Filmy f
                JOIN FilmyAktorzy fa ON f.FilmID = fa.FilmID
                WHERE fa.AktorID = v_aktor_id)
    LOOP
        v_result_temp := v_result_temp || 'FilmID: ' || rec.FilmID || ', Tytul: ' || rec.Tytul || ', Data Premiery: ' || TO_CHAR(rec.DataPremiery, 'DD-MM-YYYY') ||
                         ', Gatunek: ' || rec.Gatunek || ', Opis: ' || SUBSTR(rec.Opis, 1, 100) || '..., Budzet: ' || rec.Budzet || ', Przychody: ' || rec.Przychody || '; ';
    END LOOP;

    p_result := v_result_temp;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_result := 'Brak filmów dla podanego aktora: ' || p_imie_nazwisko;
    WHEN VALUE_ERROR THEN
        p_result := 'Błąd: Nieprawidłowy format danych. ID aktora nie jest liczbą.';
    WHEN OTHERS THEN
        p_result := 'Błąd: ' || SQLERRM;
END;
/
