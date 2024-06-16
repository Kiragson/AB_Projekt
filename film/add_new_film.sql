create or replace FUNCTION add_new_film(
    p_tytul IN VARCHAR2,
    p_data_premiery IN DATE,
    p_gatunek IN VARCHAR2,
    p_opis IN CLOB,
    p_budzet IN NUMBER,
    p_przychody IN NUMBER
) RETURN NUMBER IS
    v_film_id NUMBER;
BEGIN
    SELECT film_id_seq.NEXTVAL INTO v_film_id FROM dual;

    INSERT INTO Filmy (FilmID, Tytul, DataPremiery, Gatunek, Opis, Budzet, Przychody)
    VALUES (v_film_id, p_tytul, p_data_premiery, p_gatunek, p_opis, p_budzet, p_przychody);

    RETURN v_film_id;
EXCEPTION
    WHEN OTHERS THEN
        RETURN SQLCODE; -- Zwraca kod błędu SQL
END;
/