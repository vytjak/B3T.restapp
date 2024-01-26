table 79910 "WS Log Setup B3T"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(10; "Log Level"; enum "WS Log Level PMH.B3T")
        {
            InitValue = 4; //Debug
        }
        field(20; "Log Asynchronously"; Boolean)
        {
            InitValue = true;
        }
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