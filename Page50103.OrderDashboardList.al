page 50103 "Order Dashboard List"
{
    ApplicationArea = All;
    Caption = 'Order List';
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    
    layout
    {
        area(Content)
        {
            repeater(Orders)
            {
                field(Status; GetOrderStatusText())
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    StyleExpr = GetStatusStyle();
                    ToolTip = 'Order status with color coding';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Order number';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer number';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Customer name';
                }
                field("Order Priority"; Rec."Order Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Order priority level';
                    StyleExpr = GetPriorityStyle();
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document date';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Due date';
                    StyleExpr = GetDueDateStyle();
                }
                field("Expected Ship Date"; Rec."Expected Ship Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Expected ship date';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Order amount';
                    DecimalPlaces = 0:2;
                    StyleExpr = GetValueStyle();
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount including VAT';
                    DecimalPlaces = 0:2;
                }
                field("Order Value Rank"; Rec."Order Value Rank")
                {
                    ApplicationArea = All;
                    Caption = 'Value %';
                    ToolTip = 'Order value as percentage of total';
                    DecimalPlaces = 0:1;
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                Image = Export;
                ToolTip = 'Export orders to Excel';
                
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer";
                begin
                    ExcelBuffer.CreateBookAndOpenExcel('', 'Order Dashboard', 'Order Dashboard', COMPANYNAME, USERID);
                    ExcelBuffer.WriteSheet('Orders', COMPANYNAME, USERID);
                    ExcelBuffer.CloseBook();
                end;
            }
            action(ViewOrderDetails)
            {
                ApplicationArea = All;
                Caption = 'View Order Details';
                Image = View;
                ToolTip = 'View full order details';
                
                trigger OnAction()
                begin
                    Page.Run(Page::"Sales Order", Rec);
                end;
            }
        }
    }
    
    trigger OnAfterGetRecord()
    begin
        // This will be called for each record to update styling
    end;
    
    procedure SetFilters(var SalesHeader: Record "Sales Header")
    begin
        Rec.SetCurrentKey("Document Type", "No.");
        Rec.CopyFilters(SalesHeader);
        CurrPage.Update(false);
    end;
    
    procedure GetOrderStatusText(): Text
    begin
        case Rec.Status of
            Rec.Status::Open:
                exit('🟢 Open');
            Rec.Status::Released:
                exit('🟡 Released');
            Rec.Status::"Pending Approval":
                exit('🟠 Pending Approval');
            Rec.Status::"Pending Prepayment":
                exit('🟠 Pending Prepayment';
            else
                exit('🔴 ' + Format(Rec.Status));
        end;
    end;
    
    procedure GetStatusStyle(): Text
    begin
        case Rec.Status of
            Rec.Status::Open, Rec.Status::Released:
                exit('Favorable');
            Rec.Status::"Pending Approval", Rec.Status::"Pending Prepayment":
                exit('Ambiguous');
            else
                exit('Standard');
        end;
    end;
    
    procedure GetPriorityStyle(): Text
    begin
        case Rec."Order Priority" of
            Rec."Order Priority"::High, Rec."Order Priority"::Urgent:
                exit('Attention');
            Rec."Order Priority"::Low:
                exit('Subordinate');
            else
                exit('Standard');
        end;
    end;
    
    procedure GetDueDateStyle(): Text
    begin
        if (Rec."Due Date" <> 0D) and (Rec."Due Date" < WorkDate()) then
            exit('Attention');
        exit('Standard');
    end;
    
    procedure GetValueStyle(): Text
    begin
        if Rec.Amount > 10000 then
            exit('Favorable');
        if Rec.Amount < 1000 then
            exit('Subordinate');
        exit('Standard');
    end;
}