enumextension 50100 "Order Status Extension" extends "Sales Document Status"
{
    value(50100; "In Progress")
    {
        Caption = 'In Progress';
    }
    value(50101; "Ready to Ship")
    {
        Caption = 'Ready to Ship';
    }
    value(50102; "Shipped")
    {
        Caption = 'Shipped';
    }
    value(50103; "Invoiced")
    {
        Caption = 'Invoiced';
    }
}