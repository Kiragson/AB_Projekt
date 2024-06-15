CREATE OR REPLACE PROCEDURE usun_film (
    p_film_id IN NUMBER
) IS
    v_result NUMBER;
BEGIN
    -- Walidacja, czy film istnieje
    IF NOT FilmExists(p_film_id) THEN
        v_result := log_film_action(p_film_id, 'FAIL', 'Film o podanym ID nie istnieje.');
        RAISE_APPLICATION_ERROR(-20001, 'Film o podanym ID nie istnieje.');
    END IF;

    -- Usunięcie powiązanych ról z tabeli FilmyAktorzy
    v_result := DeleteFilmRoles(p_film_id);
    IF v_result = -1 THEN
        v_result := log_film_action(p_film_id, 'ERROR', 'Błąd podczas usuwania ról filmu.');
        RAISE_APPLICATION_ERROR(-20002, 'Błąd podczas usuwania ról filmu.');
    END IF;

    -- Usunięcie filmu
    DELETE FROM Filmy WHERE FilmID = p_film_id;

    -- Logowanie udanego usunięcia filmu
    v_result := log_film_action(p_film_id, 'SUCCESS', 'Film i powiązane role zostały usunięte.');

    DBMS_OUTPUT.PUT_LINE('Film i powiązane role zostały usunięte.');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        v_result := log_film_action(p_film_id, 'ERROR', 'Błąd: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20003, 'Błąd podczas usuwania filmu: ' || SQLERRM);
END usun_film;
/
