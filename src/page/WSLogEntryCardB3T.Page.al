page 79912 "WS Log Entry Card B3T"
{
    PageType = Card;
    SourceTable = "WS Log Entry B3T";
    Caption = 'WS Log Entry';
    Editable = false;

    layout
    {
        area(content)
        {
            Group(General)
            {
                field("Request Method"; Rec."Request Method")
                {
                    Tooltip = 'Specifies the Request Method';
                    ApplicationArea = All;
                }
                field("Request URL"; Rec."Request URL")
                {
                    Tooltip = 'Specifies the Request URL';
                    ApplicationArea = All;
                }
                field("Content Type"; Rec."Content Type")
                {
                    Tooltip = 'Specifies the Content Type';
                    ApplicationArea = All;
                }
                field("DateTime Created"; Rec."DateTime Created")
                {
                    Tooltip = 'Specifies the DateTimeCreated';
                    ApplicationArea = All;
                }
                field("Duration"; Rec."Duration")
                {
                    Tooltip = 'Specifies the Duration';
                    ApplicationArea = All;
                }
                field(User; Rec.User)
                {
                    Tooltip = 'Specifies the User';
                    ApplicationArea = All;
                }
            }

            //TODO!!!

            // Group(Request)
            // {
            //     field("Request Body Size"; Rec."Request Body Size")
            //     {
            //         Tooltip = 'Specifies the Request Body Size';
            //         ApplicationArea = All;
            //     }
            //     field("Request Headers"; Rec."Request Headers")
            //     {
            //         Tooltip = 'Specifies the Request Headers';
            //         ApplicationArea = All;
            //     }
            // }
            // group(Response)
            // {
            //     field("Response Http Status Code"; Rec."Response Http Status Code")
            //     {
            //         Tooltip = 'Specifies the Response Http Status Code';
            //         ApplicationArea = All;
            //     }
            //     field("Response Size"; Rec."Response Size")
            //     {
            //         Tooltip = 'Specifies the ResponseSize';
            //         ApplicationArea = All;
            //     }
            // }
        }
    }

}
