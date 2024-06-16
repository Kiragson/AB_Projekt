CREATE OR REPLACE PROCEDURE edytuj_film (
    p_film_id IN NUMBER,
    p_tytul IN VARCHAR2,
    p_data_premiery IN DATE,
    p_gatunek IN VARCHAR2,
    p_opis IN CLOB,
    p_budzet IN NUMBER,
    p_przychody IN NUMBER
) IS
    v_exists NUMBER;
    v_result NUMBER;
BEGIN
    -- Walidacja, czy film istnieje
    SELECT COUNT(1) INTO v_exists FROM Filmy WHERE FilmID = p_film_id;
    IF v_exists = 0 THEN
        v_result := log_film_action(p_film_id, 'FAIL', 'Film o podanym ID nie istnieje.');
        RAISE_APPLICATION_ERROR(-20001, 'Film o podanym ID nie istnieje.');
    END IF;

    -- Sprawdzenie, czy istnieje inny film z takim samym tytulem
    IF AnotherFilmExists(p_film_id, p_tytul) THEN
        v_result := log_film_action(p_film_id, 'FAIL', 'Inny film o takim samym tytule już istnieje.');
        RAISE_APPLICATION_ERROR(-20002, 'Inny film o takim samym tytule już istnieje.');
    END IF;

    -- Aktualizacja danych filmu
    UPDATE Filmy
    SET Tytul = p_tytul,
        DataPremiery = p_data_premiery,
        Gatunek = p_gatunek,
        Opis = p_opis,
        Budzet = p_budzet,
        Przychody = p_przychody
    WHERE FilmID = p_film_id;

    -- Logowanie udanej aktualizacji
    v_result := log_film_action(p_film_id, 'SUCCESS', 'Film został zaktualizowany.');

    DBMS_OUTPUT.PUT_LINE('Film został zaktualizowany.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_film_action(p_film_id, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20003, 'Błąd podczas aktualizacji filmu: ' || SQLERRM);
END edytuj_film;
/
