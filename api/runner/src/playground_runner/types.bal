const RunCmd = "Run";
const StopCmd = "Stop";

type Command RunCmd|StopCmd;

type RunData record {
    string sourceCode;
    string 'version = "1.0.1";
};

type RequestData RunData|();

type RunnerRequest record {
    Command cmd;
    RequestData data;
};

const ErrorResponse = "Error";
const DataResponse = "Data";
const ControlResponse = "Control";

type ResponseType ErrorResponse|DataResponse|ControlResponse;

type RunnerResponse record {
    ResponseType 'type;
    string? data;
};