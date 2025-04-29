CREATE FRAME main
AS
    RETURN PUT.LIST(
        @data =  (SELECT LIMIT 100 * FROM customer c WHERE c.credit_limit > 0 FILTER AUTO),
        @filters = (
            PUT.SEARCH_BAR(
                PUT.SEARCH_PROMPT(@filter = c.cust_name,@condition = 'contains')
                PUT.SEARCH_PROMPT(@filter = c.city,@condition = 'contains',@icon = 'location')
            )
        )
        @columns = (
            PUT.COLUMN(c.cust_id) 
            PUT.COLUMN(c.cust_name @stretch = true) 
            PUT.COLUMN(c.city @footer = PUT(TOTAL(c.credit_limit @type = 'avg') @suffix = 'avg')),
            PUT.COLUMN(c.state @footer = PUT(TOTAL(@type = 'count') @suffix = 'customers')),
            PUT.COLUMN(c.credit_limit @footer = PUT(TOTAL(c.credit_limit) @text-style='bold'))
        )
        @breaks = PUT.GROUP_BREAK(
            @breakon = c.state
            @header = PUT.FIELD(c.state,@label = 'State',@text-style='bold')
        )
        @onrowclick = OPEN(record,@cust_id = c.cust_id)
        @row-menu = (
            PUT.BUTTON('Activate',@onclick = OPEN(activate,@cust_id = SELECTED_ROWS(c.cust_id)))
            PUT.BUTTON('Deactivate',@onclick = OPEN(deactivate,@cust_id = c.cust_id))
        )
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

CREATE FRAME edit
    @cust_id LIKE customer.cust_id
    @customer RECORD LIKE customer = (SELECT * FROM customer c WHERE c.cust_id = @cust_id)
AS BEGIN
    RETURN PUT.FORM(
        @title = 'Edit customer'
        @body = PUT.FIELDSET(
            PUT.INPUT(@value = @customer.cust_name)
            PUT.INPUT(@value = @customer.city,@onchange ='city_changed')
            PUT.INPUT(@value = @customer.state)
        )
        @footer = PUT.BUTTON('Save',@onclick = 'submit')
    )
    ON ACTION 'submit' BEGIN
        RAISE UPDATED_TABLE([customer]),CLOSE_FRAME()
    END
END

CREATE FRAME activate
    @cust_id LIKE customer.cust_id
AS BEGIN
    RETURN PUT.FORM(
        @title = 'Activate customer'
        @data = (SELECT * FROM customer c WHERE c.cust_id = @cust_id)
        @body = (
           PUT.FIELD(c.cust_name)
        )
    )
END

CREATE FRAME deactivate
    @cust_id LIKE customer.cust_id
AS BEGIN
    RETURN PUT.FORM(
        @title = 'Deactivate customer'
        @data = (SELECT * FROM customer c WHERE c.cust_id = @cust_id)
        @body = (
            PUT.FIELD(c.cust_name)
        )
    )
END

CREATE FRAME invoice_list
AS RETURN PUT.LIST(
    @data = (SELECT LIMIT 200 * FROM invoice_header ih ),
    @columns = (
        PUT.COLUMN(ih.invoice_id)
        PUT.COLUMN(ih.invoice_date)
        PUT.COLUMN(ih.soldto_id)
        PUT.COLUMN(ih.status)
        PUT.COLUMN(ih.shipmode)
        PUT.COLUMN(ih.total)
    )
    @onrowclick = OPEN(invoice_record,@invoice_id = ih.invoice_id)
)

CREATE FRAME invoice_record
    @invoice_id LIKE invoice_header.invoice_id
AS RETURN PUT.RECORD(
    @data = (SELECT * FROM invoice_header ih WHERE ih.invoice_id = @invoice_id)
    @label = 'Invoice',
    @title = ih.invoice_id
    @banner = (
        PUT.FIELD(ih.invoice_date)
        PUT.FIELD(ih.soldto_id)
        PUT.FIELD(ih.status)
        PUT.FIELD(ih.shipmode)
        PUT.FIELD(ih.total)
    )
    @sidebar = PUT.FIELDSET(
        PUT.FIELD(ih.invoice_date)
        PUT.FIELD(ih.soldto_id)
        PUT.FIELD(ih.status)
        PUT.FIELD(ih.shipmode)
        PUT.FIELD(ih.total)
    )   
    @tabs = (
        PUT.TAB(@label = 'Items',OPEN(items_tab,@invoice_id = ih.invoice_id))
        PUT.TAB(@label = 'Shipments')
    )
)

CREATE FRAME items_tab
    @invoice_id LIKE invoice_detail.invoice_id
AS RETURN PUT.LIST(
    @data = (SELECT * FROM invoice_detail id WHERE id.invoice_id = @invoice_id)
    @columns = (
        PUT.COLUMN(id.product_id)
        PUT.COLUMN(id.descrip)
        PUT.COLUMN(id.qty)
        PUT.COLUMN(id.price)
        PUT.COLUMN(id.amount)
        PUT.COLUMN(id.discount)
    )
)


