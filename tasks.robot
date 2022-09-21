*** Settings ***
Documentation       Split and combine multiple input Work Items into one output.

Library    RPA.Robocorp.WorkItems


*** Keywords ***
Make It Square
    [Documentation]    Gets the current number in sequence and returns its square.

    ${nr} =    Get Work Item Variable    nr
    RETURN    ${nr ** 2}


*** Tasks ***
Number To Sequence
    [Documentation]    Creates a `number` of output Work Items in increasing order.

    ${number} =    Get Work Item Variable    number
    FOR    ${nr}    IN RANGE    1    ${number + 1}
        # Every output item contains a `nr` variable equal to the order of it.
        &{vars} =    Create Dictionary    nr    ${nr}
        Create Output Work Item    ${vars}    save=${True}
    END


Sequence To Total
    [Documentation]    Sums up all the squared numbers in the sequence.

    # Keep a reference to both the initial and output Work Items in order to restore
    #  them later on.
    ${item_in} =    Get Current Work Item  # initial input item already available
    ${item_out} =    Create Output Work Item    save=${True}  # output with above parent
    Set Current Work Item    ${item_in}  # sets the internal queue back to the initial one

    # Take every input in the queue, obtain their sequence numbers and get the squares
    #  of them.
    @{squares} =    For Each Input Work Item    Make It Square
    # The returned list of results is summed up into a total.
    ${total} =    Evaluate    sum(${squares})

    # We get back to our already created and saved empty output Work Item and this time
    #  we set for the first time a variable inside of it, the total obtained above.
    Set Current Work Item    ${item_out}
    Set Work Item Variable    total    ${total}
    Save Work Item  # and we save the altered item again


Process Total
    [Documentation]    Retrieve the total computed earlier and display it.

    ${total} =    Get Work Item Variable    total
    Log    Total: ${total}
