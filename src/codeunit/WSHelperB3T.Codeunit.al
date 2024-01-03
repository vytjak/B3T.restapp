codeunit 79911 "WS Helper B3T"
{
    var
        WebClient: HttpClient;
        WebRequest: HttpRequestMessage;
        WebResponse: HttpResponseMessage;
        WebRequestHeaders: HttpHeaders;
        WebContentHeaders: HttpHeaders;
        WebContentReq: HttpContent;
        CurrentContentType: Text;
        RequestHeaders: TextBuilder;
        ContentTypeSet: Boolean;
        SendSuccess: Boolean;

    procedure Initialize(Method: Text; URI: Text);
    begin
        WebRequest.Method := Method;
        WebRequest.SetRequestUri(URI);

        WebRequest.GetHeaders(WebRequestHeaders);
        SendSuccess := false;
    end;

    procedure AddRequestHeader(HeaderKey: Text; HeaderValue: Text)
    begin
        RequestHeaders.AppendLine(HeaderKey + ': ' + HeaderValue);

        WebRequestHeaders.Add(HeaderKey, HeaderValue);
    end;

    procedure AddBody(Body: Text)
    begin
        WebContentReq.WriteFrom(Body);

        ContentTypeSet := true;
    end;

    procedure SetBasicAuth(UserName: Text; Password: Text)
    var
        AuthString: Text;
        BasicAuthLbl: Label '%1:%2', Locked = true;
        AuthHeaderValue: Text;
    begin
        AuthString := StrSubstNo(BasicAuthLbl, UserName, Password);
        AuthHeaderValue := 'Basic ' + TextToBase64(AuthString);
        WebRequestHeaders.Remove('Authorization');
        WebRequestHeaders.Add('Authorization', AuthHeaderValue);
    end;

    procedure SetContentType(ContentType: Text)
    begin
        CurrentContentType := ContentType;

        WebContentReq.GetHeaders(WebContentHeaders);
        if WebContentHeaders.Contains('Content-Type') then begin
            WebContentHeaders.Remove('Content-Type');
        end;
        WebContentHeaders.Add('Content-Type', ContentType);
    end;

    procedure Send(): Boolean
    var
        StartDateTime: DateTime;
        TotalDuration: Duration;
    begin
        if (ContentTypeSet) then begin
            WebRequest.Content(WebContentReq);
        end;
        OnBeforeSend(WebRequest);
        StartDateTime := CurrentDateTime();
        Clear(WebResponse);
        SendSuccess := WebClient.Send(WebRequest, WebResponse);
        TotalDuration := CurrentDateTime() - StartDateTime;
        OnAfterSend(WebRequest, WebResponse);

        if (SendSuccess) then begin
            if (not WebResponse.IsSuccessStatusCode()) then begin
                SendSuccess := false;
            end;
        end;

        Log(StartDateTime, TotalDuration);
    end;

    procedure GetResponseContentAsText() ResponseContentText: Text
    var
        TempBlob: Record "TempBlob B3T";
        InStr: InStream;
    begin

        TempBlob.Blob.CreateInStream(InStr);
        WebResponse.Content().ReadAs(ResponseContentText);
    end;

    procedure GetResponseReasonPhrase(): Text
    begin
        exit(WebResponse.ReasonPhrase());
    end;

    procedure GetHttpStatusCode(): Integer
    begin
        exit(WebResponse.HttpStatusCode());
    end;

    procedure IsHttpStatusCodeSuccess(): Boolean
    begin
        exit(WebResponse.IsSuccessStatusCode());
    end;

    procedure TextToBase64(String: Text): Text
    var
        ConvertText: Codeunit "Convert Text B3T";
    begin
        Exit(ConvertText.TextToBase64String(String));
    end;

    local procedure Log(StartDateTime: DateTime; TotalDuration: Duration)
    var
        WSLogEntry: Record "WS Log Entry B3T";
        InStr: InStream;
        ResponseInStr: InStream;
        OutStr: OutStream;
        WebContentResp: HttpContent;
        RespContentOk: Boolean;
    begin
        WSLogEntry.Init();
        WSLogEntry."DateTime Created" := StartDateTime;
        WSLogEntry."Request URL" := CopyStr(WebRequest.GetRequestUri(), 1, MaxStrLen(WSLogEntry."Request URL"));
        WSLogEntry."Request Method" := CopyStr(WebRequest.Method, 1, MaxStrLen(WSLogEntry."Request Method"));

        WebContentReq.ReadAs(InStr);
        WSLogEntry."Request Body".CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        WSLogEntry."Request Body Size" := WSLogEntry."Request Body".Length();
        WSLogEntry."Content Type" := CopyStr(CurrentContentType, 1, MaxStrLen(WSLogEntry."Content Type"));
        WSLogEntry."Request Headers".CreateOutStream(OutStr);
        OutStr.Write(RequestHeaders.ToText());

        if (SendSuccess) then begin
            WSLogEntry."Response Http Status Code" := GetHttpStatusCode();
        end;
        WebContentResp := WebResponse.Content;
        RespContentOk := WebContentResp.ReadAs(ResponseInStr);
        if (RespContentOk) then begin
            WSLogEntry."Response Body".CreateOutStream(OutStr);
            CopyStream(OutStr, ResponseInStr);
            WSLogEntry."Response Size" := WSLogEntry."Response Body".Length();
        end;

        WSLogEntry.User := CopyStr(UserId(), 1, MaxStrLen(WSLogEntry.User));

        WSLogEntry.Duration := TotalDuration;

        //TODO: uncomment
        //if (not WSLogSetup."Log Asynchronously") then begin
        //    WSLogEntry.Insert();
        //end else begin
        LogEventAsync(WSLogEntry);
        //end;

    end;

    local procedure LogEventAsync(var LogEntry: Record "WS Log Entry B3T")
    var
        LogSessionID: Integer;
    begin
        StartSession(LogSessionID, CODEUNIT::"WS Log Management B3T", COMPANYNAME(), LogEntry);
    end;


    [IntegrationEvent(true, false)]
    local procedure OnBeforeSend(var WebRequest: HttpRequestMessage)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSend(var WebRequest: HttpRequestMessage; var WebResponse: HttpResponseMessage)
    begin
    end;
}