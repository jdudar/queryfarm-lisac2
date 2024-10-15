CREATE OR ALTER QUERY [crm].[customer_list]
    @name LIKE customer.name = NULL
AS
    SELECT TOP 100 * FROM [customer]
    FOR GRID
        TITLE 'Customer list'
        LINK [customer_record] @custid = [custid]
    AS BEGIN
        PRINT [custid]
        PRINT [name] STRETCH true SORT true
        PRINT [CITY]
        PRINT [STATE]
        
        FILTERS:
            INPUT @name FILTER [name] CONTAINS @name LABEL 'Search name'
        
        EMPTY:
            PRINT 'No matching customers found.' ICON 'truck'
            PRINT 'You can try adjusting the filters to display more results.'
            BUTTON 'Add customer'
    END
