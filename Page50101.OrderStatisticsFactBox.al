page 50101 "Order Statistics FactBox"
{
    ApplicationArea = All;
    Caption = 'Order Statistics';
    PageType = CardPart;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Order));
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Order Statistics';
                
                field(TotalOrders; TotalOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Total Orders';
                    ToolTip = 'Total number of orders';
                }
                field(OpenOrders; OpenOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Open Orders';
                    ToolTip = 'Number of open orders';
                    Style = Favorable;
                    StyleExpr = true;
                }
                field(ReleasedOrders; ReleasedOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Released Orders';
                    ToolTip = 'Number of released orders';
                    Style = Favorable;
                    StyleExpr = true;
                }
                field(PendingOrders; PendingOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Pending Orders';
                    ToolTip = 'Number of pending orders';
                    Style = Unfavorable;
                    StyleExpr = true;
                }
                field(TotalValue; TotalValue)
                {
                    ApplicationArea = All;
                    Caption = 'Total Value';
                    ToolTip = 'Total value of all orders';
                    DecimalPlaces = 0:2;
                }
                field(AverageOrderValue; AverageOrderValue)
                {
                    ApplicationArea = All;
                    Caption = 'Average Order Value';
                    ToolTip = 'Average value per order';
                    DecimalPlaces = 0:2;
                }
            }
            group(TodayStats)
            {
                Caption = 'Today''s Statistics';
                
                field(TodayOrders; TodayOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Orders';
                    ToolTip = 'Number of orders created today';
                }
                field(TodayValue; TodayValue)
                {
                    ApplicationArea = All;
                    Caption = 'Today''s Value';
                    ToolTip = 'Total value of today''s orders';
                    DecimalPlaces = 0:2;
                }
                field(OverdueOrders; OverdueOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Orders';
                    ToolTip = 'Number of overdue orders';
                    Style = Attention;
                    StyleExpr = OverdueOrders > 0;
                }
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(RefreshStatistics)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Refresh statistics';
                
                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
    }
    
    trigger OnAfterGetRecord()
    begin
        CalculateStatistics();
    end;
    
    var
        TotalOrders: Integer;
        OpenOrders: Integer;
        ReleasedOrders: Integer;
        PendingOrders: Integer;
        TotalValue: Decimal;
        AverageOrderValue: Decimal;
        TodayOrders: Integer;
        TodayValue: Decimal;
        OverdueOrders: Integer;
    
    local procedure CalculateStatistics()
    var
        SalesHeader: Record "Sales Header";
    begin
        // Total Orders
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Document Date", CalcDate('<-90D>', Today), Today);
        TotalOrders := SalesHeader.Count;
        
        // Open Orders
        SalesHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::Open, SalesHeader.Status::Released);
        OpenOrders := SalesHeader.Count;
        
        // Released Orders
        SalesHeader.SetRange(Status, SalesHeader.Status::Released);
        ReleasedOrders := SalesHeader.Count;
        
        // Open Orders (excluding Released)
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        OpenOrders := OpenOrders + SalesHeader.Count;
        
        // Pending Orders
        SalesHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::"Pending Approval", SalesHeader.Status::"Pending Prepayment");
        PendingOrders := SalesHeader.Count;
        
        // Total Value
        SalesHeader.SetRange(Status);
        SalesHeader.CalcSums(Amount);
        TotalValue := SalesHeader.Amount;
        
        // Average Order Value
        if TotalOrders > 0 then
            AverageOrderValue := TotalValue / TotalOrders;
        
        // Today's Statistics
        SalesHeader.SetRange("Document Date", Today, Today);
        TodayOrders := SalesHeader.Count;
        SalesHeader.CalcSums(Amount);
        TodayValue := SalesHeader.Amount;
        
        // Overdue Orders
        SalesHeader.SetRange("Document Date");
        SalesHeader.SetRange("Due Date", 0D, WorkDate() - 1);
        SalesHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::Open, SalesHeader.Status::Released);
        OverdueOrders := SalesHeader.Count;
    end;
}