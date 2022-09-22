*** Settings ***
Documentation       Count how many robot parts are needed for each type given all the
...    orders.

Library    Collections
Library    RPA.Desktop
Library    RPA.PDF
Library    RPA.Robocorp.WorkItems
Library    RPA.Tables


*** Keywords ***
Add Parts To Total
    [Documentation]    Adds the current order to the total number of parts to order.
    [Arguments]    ${parts}

    # A dictionary with the number of heads, bodies and legs from the order.
    &{order} =    Get Work Item Variables

    # Add the number of heads from the current order to the existing total.
    ${current_heads} =    Get From Dictionary    ${parts}    heads
    ${order_heads} =    Convert To Integer    ${order}[heads]
    ${total_heads} =    Evaluate    ${current_heads} + ${order_heads}
    # Add the number of bodies from the current order to the existing total.
    ${current_bodies} =    Get From Dictionary    ${parts}    bodies
    ${order_bodies} =    Convert To Integer    ${order}[bodies]
    ${total_bodies} =    Evaluate    ${current_bodies} + ${order_bodies}
    # Add the number of legs from the current order to the existing total.
    ${current_legs} =    Get From Dictionary    ${parts}    legs
    ${order_legs} =    Convert To Integer    ${order}[legs]
    ${total_legs} =    Evaluate    ${current_legs} + ${order_legs}

    # Save the newly obtained totals for every part type.
    Set To Dictionary    ${parts}
    ...    heads    ${total_heads}
    ...    bodies    ${total_bodies}
    ...    legs    ${total_legs}


*** Tasks ***
Read And Split Orders
    [Documentation]    Reads the orders CSV file and creates one output Work Item for
    ...    each entry.

    # Read orders from CSV and obtain a table with them.
    ${orders_file} =    Get Work Item File    orders.csv
    ...    path=${OUTPUT_DIR}${/}orders.csv
    ${orders} =    Read table from CSV    ${orders_file}

    # For every row in the CSV file:
    FOR    ${order}    IN    @{orders}
        # Create an output Work Item containing the number of parts for each type.
        &{vars} =    Create Dictionary
        ...    heads    ${order}[Head]
        ...    bodies    ${order}[Body]
        ...    legs    ${order}[Legs]
        Create Output Work Item    ${vars}    save=${True}
    END


Compute Number Of Parts
    [Documentation]    Find out how many parts we need to order in total given each
    ...    type.

    # Keep a reference to both the initial and output Work Items in order to restore
    #  them later on.
    ${item_in} =    Get Current Work Item  # initial input item already available
    ${item_out} =    Create Output Work Item    save=${True}  # output with above parent
    Set Current Work Item    ${item_in}  # sets the internal queue back to the initial one

    # Count how many parts we have to order in total for every type. Loop all the
    #  orders and add to the total each part type.
    &{parts} =    Create Dictionary
    ...    heads    ${0}
    ...    bodies    ${0}
    ...    legs    ${0}
    For Each Input Work Item    Add Parts To Total    ${parts}

    # We get back to our already created and saved empty output Work Item and this time
    #  we set for the first time the result computed above.
    Set Current Work Item    ${item_out}
    Set Work Item Variables    &{parts}
    Save Work Item  # and we save the altered item again


Order The Parts In Bulk
    [Documentation]    Receives the number of parts to be ordered in total for every
    ...    type.

    @{part_types} =    Create List    heads    bodies    legs
    &{parts} =    Create Dictionary
    FOR    ${part_type}    IN    @{part_types}
        ${total_number} =    Get Work Item Variable    ${part_type}
        Log To Console    Let's order ${total_number} ${part_type}
        Set To Dictionary    ${parts}    ${part_type}    ${total_number}
    END

    ${invoice_pdf} =    Set Variable    ${OUTPUT_DIR}${/}invoice.pdf
    Template Html To Pdf    devdata${/}invoice-template.html    ${invoice_pdf}
    ...    variables=${parts}
    Open File    ${invoice_pdf}
