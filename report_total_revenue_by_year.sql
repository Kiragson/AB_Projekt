CREATE OR REPLACE PROCEDURE report_total_revenue_by_year (
    p_year IN NUMBER,
    p_total_revenue OUT NUMBER
) IS
BEGIN
    -- Walidacja wartości roku, aby upewnić się, że jest w realistycznym zakresie
    IF p_year IS NULL OR p_year < 1000 OR p_year > 9999 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nieprawidłowa wartość roku. Rok musi być pomiędzy 1000 a 9999.');
    END IF;

    -- Pobranie całkowitych przychodów dla danego roku
    SELECT SUM(Przychody) INTO p_total_revenue
    FROM Filmy
    WHERE EXTRACT(YEAR FROM DataPremiery) = p_year;

    -- Sprawdzenie, czy nie znaleziono danych o przychodach i ustawienie na zero
    IF p_total_revenue IS NULL THEN
        p_total_revenue := 0;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        p_total_revenue := 0;  -- Upewnienie się, że parametr wyjściowy ma domyślną wartość w przypadku błędu
        RAISE;
END report_total_revenue_by_year;
/
