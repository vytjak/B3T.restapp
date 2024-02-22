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
        Clear(WebRequest);
        Clear(WebRequestHeaders);
        Clear(WebContentHeaders);

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

        Log(StartDateTime, TotalDuration);
        exit(SendSuccess);
    end;

    procedure GetResponseContentAsText() ResponseContentText: Text
    var
        TempBlob: Record "TempBlob B3T";
        InStr: InStream;
    begin
        TempBlob.Blob.CreateInStream(InStr);
        WebResponse.Content().ReadAs(ResponseContentText);
    end;

    procedure GetResponseHeader(HeaderName: Text): Text;
    var
        HttpRespHeaders: HttpHeaders;
        HeaderValues: array[10] of Text;
        HeaderValue: Text;
        ValueX: Text;
        i0: integer;
    begin
        if (SendSuccess) then begin
            HttpRespHeaders := WebResponse.Headers;
            //#if #runtime is >= 8.0
            if (HttpRespHeaders.GetValues(HeaderName, HeaderValues)) then begin
                for i0 := 1 to 10 do begin
                    ValueX := HeaderValues[i0];
                    if (ValueX <> '') then begin
                        if (HeaderValue <> '') then begin
                            HeaderValue += ',';
                        end;
                        HeaderValue += ValueX;
                    end;
                end;
            end;
        end;
        exit(HeaderValue);
    end;

    procedure GetResponseHeaders(): HttpHeaders;
    begin
        if (SendSuccess) then begin
            exit(WebResponse.Headers);
        end;
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
        WSLogSetup: Record "WS Log Setup B3T";
        WSLogEntry: Record "WS Log Entry B3T";
        InStr: InStream;
        ResponseInStr: InStream;
        OutStr: OutStream;
        WebContentResp: HttpContent;
        RespContentOk: Boolean;
    begin
        if (not WSLogSetup.Get()) then begin
            WSLogSetup.Init();
        end;
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

        if (not WSLogSetup."Log Asynchronously") then begin
            WSLogEntry.Insert();
        end else begin
            LogEventAsync(WSLogEntry);
        end;
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