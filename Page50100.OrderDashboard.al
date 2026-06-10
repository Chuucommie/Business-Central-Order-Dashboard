page 50100 "Order Dashboard"
{
    ApplicationArea = All;
    Caption = 'Order Dashboard';
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    
    layout
    {
        area(Content)
        {
            repeater(Orders)
            {
                field(Status; GetOrderStatus())
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    StyleExpr = StatusStyle;
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
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document date';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Due date';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Order amount';
                    DecimalPlaces = 0:2;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount including VAT';
                    DecimalPlaces = 0:2;
                }
            }
        }
        area(FactBoxes)
        {
            part(OrderStatistics; "Order Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = const(Order);
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(RefreshDashboard)
            {
                ApplicationArea = All;
                Caption = 'Refresh Dashboard';
                Image = Refresh;
                ToolTip = 'Refresh the order dashboard';
                
                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
            action(ExportToExcel)
            {
                ApplicationArea = All;
                Caption = 'Export to Excel';
                Image = Export;
                ToolTip = 'Export orders to Excel';
                
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer";
                    OrderList: Page "Sales Order List";
                begin
                    ExcelBuffer.CreateBookAndOpenExcel('', 'Order Dashboard', 'Order Dashboard', COMPANYNAME, USERID);
                    ExcelBuffer.WriteSheet('Orders', COMPANYNAME, USERID);
                    ExcelBuffer.CloseBook();
                end;
            }
            action(FilterOpenOrders)
            {
                ApplicationArea = All;
                Caption = 'Show Open Orders Only';
                Image = Filter;
                ToolTip = 'Filter to show only open orders';
                
                trigger OnAction()
                begin
                    Rec.SetFilter(Status, '%1|%2', Rec.Status::Open, Rec.Status::Released);
                end;
            }
            action(FilterClosedOrders)
            {
                ApplicationArea = All;
                Caption = 'Show Closed Orders Only';
                Image = Filter;
                ToolTip = 'Filter to show only closed orders';
                
                trigger OnAction()
                begin
                    Rec.SetFilter(Status, '%1|%2', Rec.Status::"Pending Approval", Rec.Status::"Pending Prepayment");
                end;
            }
            action(ClearFilters)
            {
                ApplicationArea = All;
                Caption = 'Clear All Filters';
                Image = ClearFilter;
                ToolTip = 'Clear all filters';
                
                trigger OnAction()
                begin
                    Rec.SetFilter(Status, '');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                
                actionref(Promoted_Refresh; RefreshDashboard)
                {
                }
                actionref(Promoted_Export; ExportToExcel)
                {
                }
            }
            group(Category_Filter)
            {
                Caption = 'Filter';
                
                actionref(Promoted_OpenOrders; FilterOpenOrders)
                {
                }
                actionref(Promoted_ClosedOrders; FilterClosedOrders)
                {
                }
                actionref(Promoted_ClearFilters; ClearFilters)
                {
                }
            }
        }
    }
    
    var
        StatusStyle: Text;
    
    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;
    
    trigger OnOpenPage()
    begin
        // Set initial filter for recent orders
        Rec.SetRange("Document Date", CalcDate('<-90D>', Today), Today);
    end;
    
    local procedure SetStatusStyle()
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Favorable';
            Rec.Status::Released:
                StatusStyle := 'Favorable';
            Rec.Status::"Pending Approval":
                StatusStyle := 'Ambiguous';
            Rec.Status::"Pending Prepayment":
                StatusStyle := 'Ambiguous';
            else
                StatusStyle := 'Standard';
        end;
    end;
    
    local procedure GetOrderStatus(): Text
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
}