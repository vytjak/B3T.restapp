table 79911 "WS Log Entry B3T"
{
    // #if defined #version 20plus
    // Access = Public;
    // #endif
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(2; "Request URL"; Text[250])
        {
            Caption = 'Request URL';
        }
        field(3; "Request Method"; Code[10])
        {
            Caption = 'Request Method';
        }
        field(4; "Request Body"; Blob)
        {
            Caption = 'Request Body';
        }
        field(5; "Request Body Size"; BigInteger)
        {
            Caption = 'Request Body Size';
        }
        field(6; "Content Type"; Text[50])
        {
            Caption = 'Content Type';
        }
        field(7; "Request Headers"; Blob)
        {
            Caption = 'Request Headers';
        }
        field(8; "Response Http Status Code"; Integer)
        {
            Caption = 'Response Http Status Code';
        }
        field(9; "Response Body"; Blob)
        {
            Caption = 'Response Body';
        }
        field(10; "Response Size"; BigInteger)
        {
            Caption = 'Response Size';
        }
        field(11; "DateTime Created"; DateTime)
        {
            Caption = 'Date Time Created';
        }
        field(12; "Duration"; Duration)
        {
            Caption = 'Duration';
        }
        field(20; User; Code[50])
        {
            Caption = 'User';
            DataClassification = EndUserIdentifiableInformation;
        }

    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ShowRequestMessage()
    var
        ShowRequestMessageMeth: Codeunit "ShowRequestMessage Meth WLD";
    begin
        ShowRequestMessageMeth.ShowRequestMessage(Rec);
    end;

    procedure ShowResponseMessage()
    var
        ShowResponseMessageMeth: Codeunit "ShowResponseMessage Meth WLD";
    begin
        ShowResponseMessageMeth.ShowResponseMessage(Rec);
    end;
}