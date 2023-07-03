codeunit 79914 "WS Log Management B3T"
{
    trigger OnRun()
    begin

    end;

    procedure DownloadRequestHeaders(WSLogEntry: Record "WS Log Entry B3T")
    var
        TempBlob: Record "TempBlob B3T";
        InS: InStream;
        DefaultFileNameTxt: Label 'RequestHeaders_%1.txt', Comment = '%1 - Log Entry ID';
        FileName: Text;
    begin
        WSLogEntry.CalcFields("Request Headers");
        if (WSLogEntry."Request Headers".HasValue) then begin
            TempBlob.BLOB := WSLogEntry."Request Headers";
            TempBlob.BLOB.CreateInStream(InS);
            FileName := StrSubstNo(DefaultFileNameTxt, WSLogEntry."Entry No.");
            DownloadFromStream(InS, 'Download Headers', '', '*.txt', FileName);
        end;
    end;


    procedure DownloadRequestBody(WSLogEntry: Record "WS Log Entry B3T")
    var
        TempBlob: Record "TempBlob B3T";
        InS: InStream;
        DefaultFileNameTxt: Label 'RequestBody_%1.txt', Comment = '%1 - Log Entry ID';
        FileName: Text;
    begin
        WSLogEntry.CalcFields("Request Body");
        if (WSLogEntry."Request Body".HasValue) then begin
            TempBlob.BLOB := WSLogEntry."Request Body";
            TempBlob.BLOB.CreateInStream(InS);
            FileName := StrSubstNo(DefaultFileNameTxt, WSLogEntry."Entry No.");
            DownloadFromStream(InS, 'Download Body', '', '*.txt', FileName);
        end;
    end;

    procedure DownloadResponseBody(WSLogEntry: Record "WS Log Entry B3T")
    var
        TempBlob: Record "TempBlob B3T";
        InS: InStream;
        DefaultFileNameTxt: Label 'ResponseBody_%1.txt', Comment = '%1 - Log Entry ID';
        FileName: Text;
    begin
        WSLogEntry.CalcFields("Response Body");
        if (WSLogEntry."Response Body".HasValue) then begin
            TempBlob.BLOB := WSLogEntry."Response Body";
            TempBlob.BLOB.CreateInStream(InS);
            FileName := StrSubstNo(DefaultFileNameTxt, WSLogEntry."Entry No.");
            DownloadFromStream(InS, 'Download Body', '', '*.txt', FileName);
        end;
    end;
}