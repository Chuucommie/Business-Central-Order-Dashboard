tableextension 50100 "Sales Header Extension" extends "Sales Header"
{
    fields
    {
        field(50100; "Order Priority"; Enum "Order Priority")
        {
            Caption = 'Order Priority';
            DataClassification = CustomerContent;
            
            trigger OnValidate()
            begin
                if "Order Priority" = "Order Priority"::High then
                    "Due Date" := CalcDate('<-7D>', "Due Date");
            end;
        }
        field(50101; "Expected Ship Date"; Date)
        {
            Caption = 'Expected Ship Date';
            DataClassification = CustomerContent;
        }
        field(50102; "Order Value Rank"; Integer)
        {
            Caption = 'Order Value Rank';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50103; "Dashboard Color Code"; Code[20])
        {
            Caption = 'Dashboard Color Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    
    trigger OnAfterGet()
    begin
        CalculateOrderValueRank();
        SetDashboardColorCode();
    end;
    
    local procedure CalculateOrderValueRank()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", "Document Type"::Order);
        if SalesHeader.FindSet() then begin
            SalesHeader.CalcSums(Amount);
            if Amount > 0 then
                "Order Value Rank" := Round((Amount / SalesHeader.Amount) * 100, 1)
            else
                "Order Value Rank" := 0;
        end;
    end;
    
    local procedure SetDashboardColorCode()
    begin
        case Status of
            Status::Open:
                "Dashboard Color Code" := 'GREEN';
            Status::Released:
                "Dashboard Color Code" := 'YELLOW';
            Status::"Pending Approval":
                "Dashboard Color Code" := 'ORANGE';
            Status::"Pending Prepayment":
                "Dashboard Color Code" := 'ORANGE';
            else
                "Dashboard Color Code" := 'RED';
        end;
        
        // Override based on priority
        if "Order Priority" = "Order Priority"::High then
            "Dashboard Color Code" := 'RED';
    end;
}