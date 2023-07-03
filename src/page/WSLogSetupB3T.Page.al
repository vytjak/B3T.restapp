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
                //You might want to add fields here
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
    
}
