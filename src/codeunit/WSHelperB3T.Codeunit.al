codeunit 79911 "WS Helper B3T"
{
    // #if defined #version 20plus
    // Access = Public;
    // #endif
    //TODO: Build in RequestCatcher.com functionality so that it's easy to analyze requests that come from Business Central

    var
        WebClient: HttpClient;
        WebRequest: HttpRequestMessage;
        WebResponse: HttpResponseMessage;
        WebRequestHeaders: HttpHeaders;
        WebContentHeaders: HttpHeaders;
        WebContent: HttpContent;
        CurrentContentType: Text;
        RestHeaders: TextBuilder;
        ContentTypeSet: Boolean;

    procedure Initialize(Method: Text; URI: Text);
    begin
        WebRequest.Method := Method;
        WebRequest.SetRequestUri(URI);

        WebRequest.GetHeaders(WebRequestHeaders);
    end;

    procedure AddRequestHeader(HeaderKey: Text; HeaderValue: Text)
    begin
        RestHeaders.AppendLine(HeaderKey + ': ' + HeaderValue);

        WebRequestHeaders.Add(HeaderKey, HeaderValue);
    end;

    procedure AddBody(Body: Text)
    begin
        WebContent.WriteFrom(Body);

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

        WebContent.GetHeaders(WebContentHeaders);
        if WebContentHeaders.Contains('Content-Type') then begin
            WebContentHeaders.Remove('Content-Type');
        end;
        WebContentHeaders.Add('Content-Type', ContentType);
    end;

    procedure Send() SendSuccess: Boolean
    var
        StartDateTime: DateTime;
        TotalDuration: Duration;
    begin
        if ContentTypeSet then
            WebRequest.Content(WebContent);

        OnBeforeSend(WebRequest, WebResponse);
        StartDateTime := CurrentDateTime();
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
        RestBlob: Record "TempBlob B3T";
        //ContentData: Codeunit "Temp BLOB";
        Instr: Instream;
    begin

        RESTBlob.Blob.CreateInStream(Instr);
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
        RestBlob: record "TempBlob B3T";
        ResponseBlob: record "TempBlob B3T";
        Instr: InStream;
        ResponseInstr: InStream;
        Outstr: OutStream;
    begin
        RestBlob.BLOB.CreateInStream(Instr);
        WebContent.ReadAs(Instr);

        ResponseBlob.BLOB.CreateInStream(ResponseInstr);
        WebResponse.Content().ReadAs(ResponseInstr);

        WSLogEntry.Init();
        WSLogEntry."Request URL" := CopyStr(WebRequest.GetRequestUri(), 1, MaxStrLen(WSLogEntry."Request URL"));
        WSLogEntry."Request Method" := CopyStr(WebRequest.Method, 1, MaxStrLen(WSLogEntry."Request Method"));

        WSLogEntry."Request Body".CreateOutStream(Outstr);
        CopyStream(Outstr, Instr);

        WSLogEntry."Request Body Size" := WSLogEntry."Request Body".Length();
        WSLogEntry."Content Type" := CopyStr(CurrentContentType, 1, MaxStrLen(WSLogEntry."Content Type"));
        //TODO!!! WSLogEntry."Request Headers" := CopyStr(RestHeaders.ToText(), 1, MaxStrLen(WSLogEntry."Request Headers"));
        WSLogEntry."Response Http Status Code" := GetHttpStatusCode();

        WSLogEntry."Response Body".CreateOutStream(Outstr);
        CopyStream(Outstr, ResponseInstr);
        WSLogEntry."Response Size" := WSLogEntry."Response Body".Length();
        WSLogEntry."DateTime Created" := StartDateTime;

        WSLogEntry.User := CopyStr(UserId(), 1, MaxStrLen(WSLogEntry.User));

        WSLogEntry.Duration := TotalDuration;
        WSLogEntry.Insert();

    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeSend(WebRequest: HttpRequestMessage; WebResponse: HttpResponseMessage)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSend(WebRequest: HttpRequestMessage; WebResponse: HttpResponseMessage)
    begin
    end;
}