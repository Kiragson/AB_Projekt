CREATE OR REPLACE PROCEDURE report_total_revenue_by_year (
    p_year IN NUMBER,
    p_total_revenue OUT NUMBER
) IS
BEGIN
    SELECT SUM(Przychody) INTO p_total_revenue
    FROM Filmy
    WHERE EXTRACT(YEAR FROM DataPremiery) = p_year;
    
    IF p_total_revenue IS NULL THEN
        p_total_revenue := 0;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
        p_total_revenue := 0;
        RAISE;
END report_total_revenue_by_year;
/
