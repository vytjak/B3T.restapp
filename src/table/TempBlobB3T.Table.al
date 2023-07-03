table 79913 "TempBlob B3T"
{
    // #if defined #version 20plus
    // Access = Public;
    // #endif

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            caption = 'Primary Key';
        }

        field(2; "BLOB"; Blob)
        {
            Caption = 'BLOB';
        }

    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}