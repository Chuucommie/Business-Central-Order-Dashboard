page 50102 "Order Dashboard Card"
{
    ApplicationArea = All;
    Caption = 'Order Dashboard';
    PageType = Card;
    
    layout
    {
        area(Content)
        {
            group(DashboardFilters)
            {
                Caption = 'Dashboard Filters';
                
                field(StatusFilter; StatusFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Status Filter';
                    OptionCaption = 'All,Open,Released,Pending Approval,Pending Prepayment,Closed';
                    ToolTip = 'Filter orders by status';
                    
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
                field(DateFromFilter; DateFromFilter)
                {
                    ApplicationArea = All;
                    Caption = 'From Date';
                    ToolTip = 'Filter orders from this date';
                    
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
                field(DateToFilter; DateToFilter)
                {
                    ApplicationArea = All;
                    Caption = 'To Date';
                    ToolTip = 'Filter orders to this date';
                    
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
                field(PriorityFilter; PriorityFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Priority Filter';
                    OptionCaption = 'All,Normal,High,Low,Urgent';
                    ToolTip = 'Filter orders by priority';
                    
                    trigger OnValidate()
                    begin
                        ApplyFilters();
                    end;
                }
            }
            
            group(OrderSummary)
            {
                Caption = 'Order Summary';
                
                field(TotalFilteredOrders; TotalFilteredOrders)
                {
                    ApplicationArea = All;
                    Caption = 'Total Filtered Orders';
                    ToolTip = 'Total number of orders matching filters';
                }
                field(TotalFilteredValue; TotalFilteredValue)
                {
                    ApplicationArea = All;
                    Caption = 'Total Filtered Value';
                    ToolTip = 'Total value of orders matching filters';
                    DecimalPlaces = 0:2;
                }
            }
            
            part(OrderList; "Order Dashboard List")
            {
                ApplicationArea = All;
                Caption = 'Orders';
            }
        }
    }
    
    actions
    {
        area(Processing)
        {
            action(ExportFilteredOrders)
            {
                ApplicationArea = All;
                Caption = 'Export Filtered Orders';
                Image = Export;
                ToolTip = 'Export filtered orders to Excel';
                
                trigger OnAction()
                begin
                    CurrPage.OrderList.Page.ExportToExcel();
                end;
            }
            action(ResetFilters)
            {
                ApplicationArea = All;
                Caption = 'Reset All Filters';
                Image = ClearFilter;
                ToolTip = 'Reset all filters to default';
                
                trigger OnAction()
                begin
                    ResetDefaultFilters();
                end;
            }
        }
    }
    
    var
        StatusFilter: Option All,Open,Released,"Pending Approval","Pending Prepayment",Closed;
        DateFromFilter: Date;
        DateToFilter: Date;
        PriorityFilter: Option All,Normal,High,Low,Urgent;
        TotalFilteredOrders: Integer;
        TotalFilteredValue: Decimal;
    
    trigger OnOpenPage()
    begin
        ResetDefaultFilters();
    end;
    
    local procedure ApplyFilters()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        
        // Apply status filter
        case StatusFilter of
            StatusFilter::Open:
                SalesHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::Open, SalesHeader.Status::Released);
            StatusFilter::Released:
                SalesHeader.SetRange(Status, SalesHeader.Status::Released);
            StatusFilter::"Pending Approval":
                SalesHeader.SetRange(Status, SalesHeader.Status::"Pending Approval");
            StatusFilter::"Pending Prepayment":
                SalesHeader.SetRange(Status, SalesHeader.Status::"Pending Prepayment");
            StatusFilter::Closed:
                SalesHeader.SetFilter(Status, '%1|%2', SalesHeader.Status::"Pending Approval", SalesHeader.Status::"Pending Prepayment");
        end;
        
        // Apply date filters
        if DateFromFilter <> 0D then
            SalesHeader.SetFilter("Document Date", '%1..', DateFromFilter);
        if DateToFilter <> 0D then
            SalesHeader.SetFilter("Document Date", '..%1', DateToFilter);
        
        // Apply priority filter
        case PriorityFilter of
            PriorityFilter::Normal:
                SalesHeader.SetRange("Order Priority", "Order Priority"::Normal);
            PriorityFilter::High:
                SalesHeader.SetRange("Order Priority", "Order Priority"::High);
            PriorityFilter::Low:
                SalesHeader.SetRange("Order Priority", "Order Priority"::Low);
            PriorityFilter::Urgent:
                SalesHeader.SetRange("Order Priority", "Order Priority"::Urgent);
        end;
        
        // Calculate summary statistics
        TotalFilteredOrders := SalesHeader.Count;
        SalesHeader.CalcSums(Amount);
        TotalFilteredValue := SalesHeader.Amount;
        
        // Update the order list with new filters
        CurrPage.OrderList.Page.SetFilters(SalesHeader);
    end;
    
    local procedure ResetDefaultFilters()
    begin
        StatusFilter := StatusFilter::All;
        DateFromFilter := CalcDate('<-30D>', Today);
        DateToFilter := Today;
        PriorityFilter := PriorityFilter::All;
        ApplyFilters();
    end;
    
    procedure GetFilteredStatistics(TotalOrders: Integer; TotalValue: Decimal)
    begin
        TotalFilteredOrders := TotalOrders;
        TotalFilteredValue := TotalValue;
    end;
}