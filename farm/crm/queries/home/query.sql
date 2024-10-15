CREATE OR ALTER QUERY [crm].[home]
AS
    SELECT FOR WORKSPACE
        TITLE 'CRM'
    AS BEGIN
        
        NAV:
            BUTTON 'Customers'
                ICON 'user'
                BADGE-TEXT (SELECT
                    COUNT(*) FROM [customer])
                BADGE-COLOR 'bright-orange'
                LINK [customer_list]
            BUTTON 'Recent orders'
                ICON 'truck'
                LINK [sys].[todo] @note = 'This will show a list of recently entered orders.'
            BUTTON 'Payments'
                ICON 'money'
                LINK [sys].[todo] @note = 'This will display a list of all the recent payments received'
            BUTTON 'Dashboard'
                ICON 'barchart'
                LINK [sys].[todo] @note = 'This will display a dashboard with sales analytics'
    END