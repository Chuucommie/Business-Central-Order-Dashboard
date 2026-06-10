report 50100 "Order Dashboard Report"
{
    ApplicationArea = All;
    Caption = 'Order Dashboard Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = OrderDashboardReportLayout;
    
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "Document Date", "Due Date", Status;
            
            column(No_; "No.")
            {
            }
            column(SelltoCustomerNo_; "Sell-to Customer No.")
            {
            }
            column(SelltoCustomerName; "Sell-to Customer Name")
            {
            }
            column(Document_Date; "Document Date")
            {
            }
            column(Due_Date; "Due Date")
            {
            }
            column(Status; Status)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Amount_Including_VAT; "Amount Including VAT")
            {
            }
            column(OrderPriority; "Order Priority")
            {
            }
            column(ExpectedShipDate; "Expected Ship Date")
            {
            }
            column(OrderValueRank; "Order Value Rank")
            {
            }
            column(DashboardColorCode; "Dashboard Color Code")
            {
            }
            
            trigger OnPreDataItem()
            begin
                SetRange("Document Date", FromDate, ToDate);
            end;
        }
    }
    
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    
                    field(FromDate; FromDate)
                    {
                        ApplicationArea = All;
                        Caption = 'From Date';
                        ToolTip = 'Filter orders from this date';
                    }
                    field(ToDate; ToDate)
                    {
                        ApplicationArea = All;
                        Caption = 'To Date';
                        ToolTip = 'Filter orders to this date';
                    }
                    field(ShowStatistics; ShowStatistics)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Statistics';
                        ToolTip = 'Show order statistics summary';
                    }
                }
            }
        }
    }
    
    rendering
    {
        layout(OrderDashboardReportLayout)
        {
            Type = Excel;
            LayoutFile = 'OrderDashboardReportLayout.xlsx';
            Caption = 'Order Dashboard Report Layout';
            SummaryView = true;
        }
    }
    
    labels
    {
        OrderNoLbl = 'Order No.';
        CustomerNoLbl = 'Customer No.';
        CustomerNameLbl = 'Customer Name';
        DocumentDateLbl = 'Document Date';
        DueDateLbl = 'Due Date';
        StatusLbl = 'Status';
        AmountLbl = 'Amount';
        AmountIncludingVATLbl = 'Amount Including VAT';
        PriorityLbl = 'Priority';
        ExpectedShipDateLbl = 'Expected Ship Date';
        ValueRankLbl = 'Value %';
        ColorCodeLbl = 'Color Code';
    }
    
    var
        FromDate: Date;
        ToDate: Date;
        ShowStatistics: Boolean;
    
    trigger OnPreReport()
    begin
        if FromDate = 0D then
            FromDate := CalcDate('<-30D>', Today);
        if ToDate = 0D then
            ToDate := Today;
    end;
}