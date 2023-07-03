codeunit 79913 "ShowResponseMessage Meth WLD"
{
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
}