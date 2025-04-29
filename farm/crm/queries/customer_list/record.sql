CREATE TABLE customers(
    cust_id VARCHAR,
    cust_name VARCHAR,
    email VARCHAR,
    phone VARCHAR
)
VALUES
    ('C100','Customer 100','john@gmail.com','800-232-4423')
    ('C101','Customer 101','mike@gmail.com','552-202-0923')
    ('C101','Customer 101','susan@gmail.com','602-442-0909')


CREATE FRAME main
AS RETURN PUT.LIST(
    @data = (SELECT * FROM customer c)
    @title = 'Customer list'
    @columns = (
        PUT.COLUMN(c.cust_id)
        PUT.COLUMN(c.cust_name)
        PUT.COLUMN(c.email)
        PUT.COLUMN(c.phone)
    )
    @onrowclick = OPEN(record,@cust_id = c.cust_id)
)

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
