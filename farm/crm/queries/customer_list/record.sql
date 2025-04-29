CREATE FRAME record
    @cust_id LIKE customer.cust_id
AS BEGIN
    DECLARE @message VARCHAR
    SELECT @message = 'Hello, world!'
    RETURN PUT.RECORD(
        @data = (SELECT * FROM customer c WHERE c.cust_id = @cust_id),
        @width = '900px',
        @label = 'Customer',
        @title = c.cust_name
        @actions = (
           PUT.BUTTON('Edit', @onclick = OPEN(edit,@cust_id = c.cust_id))
        )
        @sidebar = (
           PUT.TEXT(@message)
        )
        @tabs = (
            PUT.TAB(@label = 'Orders')
            PUT.TAB(@label = 'Invoices')
        )
    )
END
