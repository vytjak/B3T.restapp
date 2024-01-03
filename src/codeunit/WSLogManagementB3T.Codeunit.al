codeunit 79914 "WS Log Management B3T"
{
    TableNo = 79911; //"WS Log Entry B3T";
    trigger OnRun()
    begin

        //IF (RequestPrepared) THEN BEGIN
        //    Send();
        //END;

        if (Rec."DateTime Created" <> 0DT) then begin
            StoreLogRecord(Rec);
        end;
    end;

    local procedure StoreLogRecord(var LogEntry: Record "WS Log Entry B3T")
    begin
        LogEntry.Insert(true);
    end;

    //#region: UI
    procedure ShowRequestMessage(var Log: Record "WS Log Entry B3T");
    var
        Handled: Boolean;
    begin
        OnBeforeShowRequestMessage(Log, Handled);

        DoShowRequestMessage(Log, Handled);

        OnAfterShowRequestMessage(Log);
    end;

    local procedure DoShowRequestMessage(var WSLogEntry: Record "WS Log Entry B3T"; var Handled: Boolean);
    var
        Instr: Instream;
        RequestMessage: Text;
    begin
        if (Handled) then
            exit;

        WSLogEntry.CalcFields("Request Body");
        WSLogEntry."Request Body".CreateInStream(Instr);
        Instr.ReadText(RequestMessage);

        Message(RequestMessage);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowRequestMessage(var Log: Record "WS Log Entry B3T"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShowRequestMessage(var Log: Record "WS Log Entry B3T");
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

    procedure ShowResponseMessage(var Log: Record "WS Log Entry B3T");
    var
        Handled: Boolean;
    begin
        OnBeforeShowResponseMessage(Log, Handled);

        DoShowResponseMessage(Log, Handled);

        OnAfterShowResponseMessage(Log);
    end;

    local procedure DoShowResponseMessage(var WSLogEntry: Record "WS Log Entry B3T"; var Handled: Boolean);
    var
        Instr: Instream;
        RequestMessage: Text;
    begin
        if Handled then
            exit;

        WSLogEntry.CalcFields("Response Body");
        WSLogEntry."Response Body".CreateInStream(Instr);
        Instr.ReadText(RequestMessage);

        Message(RequestMessage);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowResponseMessage(var Log: Record "WS Log Entry B3T"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterShowResponseMessage(var Log: Record "WS Log Entry B3T");
    begin
    end;

    /*
  //v14.0 version  
ShowRequestHeaders()
Rec.CALCFIELDS("Request Headers");
IF (Rec."Request Headers".HASVALUE) THEN BEGIN
  TempBlob.Blob := Rec."Request Headers";
  FileMan.BLOBExport(TempBlob, STRSUBSTNO('RequestHeaders_%1.txt', Rec."Entry No."), TRUE);
END;

ShowRequestBody()
Rec.CALCFIELDS("Request Body");
IF (Rec."Request Body".HASVALUE) THEN BEGIN
  TempBlob.Blob := Rec."Request Body";
  FileMan.BLOBExport(TempBlob, STRSUBSTNO('RequestBody_%1.txt', Rec."Entry No."), TRUE);
END;

ShowResponseHeaders()
Rec.CALCFIELDS("Response Headers");
IF (Rec."Response Headers".HASVALUE) THEN BEGIN
  TempBlob.Blob := Rec."Response Headers";
  FileMan.BLOBExport(TempBlob, STRSUBSTNO('ResponseHeaders_%1.txt', Rec."Entry No."), TRUE);
END;

ShowResponseBody()
Rec.CALCFIELDS("Response Body");
IF (Rec."Response Body".HASVALUE) THEN BEGIN
  TempBlob.Blob := Rec."Response Body";
  FileMan.BLOBExport(TempBlob, STRSUBSTNO('ResponseBody_%1.txt', Rec."Entry No."), TRUE);
END;
*/

}