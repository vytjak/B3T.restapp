table 79910 "WS Log Setup B3T"
{
    // #if defined #version 20plus
    // Access = Public;
    // #endif
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

        }

        //You might want to add fields here

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    begin
        Rec.Reset();
        if (not Rec.Get()) then begin
            Rec.Init();
            Rec.Insert(true);
        end;
    end;
}