CREATE OR ALTER QUERY [crm].[customer_record]
    @custid LIKE customer.custid
AS
    SELECT * FROM [customer]
    WHERE [custid] = @custid
    FOR RECORD
        LABEL 'Customer'
        TITLE [name]
    AS BEGIN
        SELECT FOR CARD
            TITLE 'Details'
        AS BEGIN
            PRINT [city]
            PRINT [state]
            PRINT [zipcode]
        END
        
        TABS:
            BUTTON 'Orders'
                LINK [customer_orders] @soldto = [custid]
            BUTTON 'Invoices'
                LINK [sys].[todo] @title = 'Coming soon',
                    @note = 'This will display a list of customer invoices'
            BUTTON 'CRM activity'
        
        ACTIONS:
            BUTTON 'Deactivate'
                LINK [deactivate_customer] @custid = [custid]
    END
