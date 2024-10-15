CREATE OR ALTER QUERY [crm].[deactivate_customer]
    @custid LIKE customer.custid
AS BEGIN
    IF @$action = 'submit'
    BEGIN
        EXEC [METHOD]
        CLOSE DIALOG
    
    END
    
    SELECT * FROM [crm].[customer]
    WHERE [custid] = @custid
    FOR DIALOG
        TITLE 'Deactive customer'
    AS BEGIN
        PRINT 'Proceed to deactivate ',
            BOLD([name]),
            '?' LABEL NULL
        
        FOOTER:
            BUTTON 'Deactivate'
                DESTRUCTIVE true
                ACTION 'submit'
    END
END