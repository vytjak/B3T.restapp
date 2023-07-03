codeunit 79912 "ShowRequestMessage Meth WLD"
{
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
}