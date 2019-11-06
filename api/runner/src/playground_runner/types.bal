const RunRequest = "Run";
const StopRequest = "Stop";

type RequestType RunRequest|StopRequest;

type RunData record {
    string sourceCode;
    string balVersion;
};

type RequestData RunData|();

type RunnerRequest record {
    RequestType 'type;
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