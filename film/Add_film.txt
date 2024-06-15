CREATE OR REPLACE PROCEDURE dodaj_film (
    p_tytul IN VARCHAR2,
    p_data_premiery IN DATE,
    p_gatunek IN VARCHAR2,
    p_opis IN CLOB,
    p_budzet IN NUMBER,
    p_przychody IN NUMBER
) IS
    v_film_id NUMBER;
    v_result NUMBER;
BEGIN
    IF NOT is_title_unique(p_tytul) THEN
        v_result := log_film_action(NULL, 'FAIL', 'Film o takim tytule już istnieje.');
        DBMS_OUTPUT.PUT_LINE('Błąd: Film o takim tytule już istnieje.');
        RETURN;
    END IF;

    v_film_id := add_new_film(p_tytul, p_data_premiery, p_gatunek, p_opis, p_budzet, p_przychody);
    IF v_film_id <= 0 THEN
        v_result := log_film_action(NULL, 'ERROR', 'Błąd podczas dodawania filmu: ' || TO_CHAR(v_film_id));
        DBMS_OUTPUT.PUT_LINE('Błąd podczas dodawania filmu: ' || TO_CHAR(v_film_id));
        RETURN;
    END IF;

    v_result := log_film_action(v_film_id, 'SUCCESS', 'Film został dodany.');
    DBMS_OUTPUT.PUT_LINE('Film został dodany. ID filmu: ' || TO_CHAR(v_film_id));
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_film_action(NULL, 'ERROR', 'Nieoczekiwany błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Nieoczekiwany błąd: ' || SQLERRM);
END dodaj_film;
/
