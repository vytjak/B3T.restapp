page 79911 "WS Log Entries B3T"
{
    PageType = List;
    SourceTable = "WS Log Entry B3T";
    Caption = 'WS Log Entries';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "WS Log Entry Card B3T";
    SourceTableView = sorting("Entry No.") order(descending);

    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Tooltip = 'Specifies the Entry No.';

                    ApplicationArea = All;
                }
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
                    Tooltip = 'Specifies the ContentType';

                    ApplicationArea = All;
                }
                field("DateTime Created"; Rec."DateTime Created")
                {
                    Tooltip = 'Specifies the DateTime Created';

                    ApplicationArea = All;
                }
                field("Duration"; Rec."Duration")
                {
                    Tooltip = 'Specifies the Duration';

                    ApplicationArea = All;
                }
                field("Request Body Size"; Rec."Request Body Size")
                {
                    BlankZero = true;
                    Tooltip = 'Specifies the Request Body Size';

                    ApplicationArea = All;
                }
                //TODO: 
                // field("Request Headers"; Rec."Request Headers")
                // {
                //     Tooltip = 'Specifies the Request Headers';
                //     ApplicationArea = All;
                // }
                field("Response Http Status Code"; Rec."Response Http Status Code")
                {
                    BlankZero = true;
                    Tooltip = 'Specifies the Response Http Status Code';

                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'HTTP status or error description.';

                    ApplicationArea = All;
                }
                field("Response Size"; Rec."Response Size")
                {
                    BlankZero = true;
                    Tooltip = 'Specifies the Response Size';

                    ApplicationArea = All;
                }
                field(User; User)
                {
                    Tooltip = 'Specifies the User';

                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ActDownloadRequestHeaders)
            {
                Caption = 'Download Request Headers';
                Image = ExportFile;
                Tooltip = 'Downloads request headers';
                Promoted = true;
                PromotedCategory = Process;

                ApplicationArea = All;

                trigger OnAction()
                begin
                    WSLogMan.DownloadRequestHeaders(Rec);
                end;
            }
            action(ActDownloadRequestBody)
            {
                Caption = 'Download Request Body';
                Image = ExportFile;
                Tooltip = 'Downloads request body, if present.';
                Promoted = true;
                PromotedCategory = Process;

                ApplicationArea = All;

                trigger OnAction()
                begin
                    WSLogMan.DownloadRequestBody(Rec);
                end;
            }

            action(ActDownloadResponseBody)
            {
                Caption = 'Download Response Body';
                Image = ExportFile;
                Tooltip = 'Downloads response body, if present.';
                Promoted = true;
                PromotedCategory = Process;

                ApplicationArea = All;

                trigger OnAction()
                begin
                    WSLogMan.DownloadResponseBody(Rec);
                end;
            }

            action(ShowRequestMessage)
            {
                Tooltip = 'Shows the request message';
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Show Request Message';
                Scope = "Repeater";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    WSLogMan.ShowRequestMessage(Rec);
                end;
            }
            action(ShowResponseMessage)
            {
                Tooltip = 'Shows the response message';
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Show Response Message';
                Scope = "Repeater";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    WSLogMan.ShowResponseMessage(Rec);
                end;
            }
        }
    }

    var
        WSLogMan: Codeunit "WS Log Management B3T";

}
