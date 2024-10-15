CREATE OR ALTER QUERY [crm].[customer_orders]
    @soldto LIKE order_hdr.SOLDTO
AS
    SELECT TOP 100 * FROM [order_hdr]
    WHERE [SOLDTO] = @soldto
    ORDER BY [date] DESC
    FOR GRID
        LINK [sys].[todo] @title = 'TO DO',
            @note = 'Display order details'
    AS BEGIN
        PRINT [id]
        PRINT [CUSTORD]
        PRINT [ShipMode]
        PRINT [DATE]
        PRINT [DATEREQ]
        PRINT [STATUS]
        
        EMPTY:
            PRINT 'No orders found.' ICON 'truck'
            PRINT 'As orders are created they will appear here.'
    END
