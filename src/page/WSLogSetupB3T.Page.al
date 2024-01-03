page 79910 "WS Log Setup B3T"
{
    PageType = Card;
    SourceTable = "WS Log Setup B3T";
    Caption = 'WS Log Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Log Level"; Rec."Log Level")
                {
                    ToolTip = 'Log Level';

                    ApplicationArea = All;
                }
                field("Log Asynchronously"; Rec."Log Asynchronously")
                {
                    ToolTip = 'Log Asynchronously';

                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
