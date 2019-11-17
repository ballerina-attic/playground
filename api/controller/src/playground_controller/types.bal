const RunRequest = "Run";
const StopRequest = "Stop";

type RequestType RunRequest|StopRequest;

type RunData record {
    string sourceCode;
    string balVersion;
};

type RequestData RunData|();

type PlaygroundRequest record {
    RequestType 'type;
    RequestData data;
};

const ErrorResponse = "Error";
const DataResponse = "Data";
const ControlResponse = "Control";

type ResponseType ErrorResponse|DataResponse|ControlResponse;

type PlaygroundResponse record {
    ResponseType 'type;
    string? data;
};

type CompilerCompletionCallback function (boolean isSuccess) returns ();

type ResponseHandler function (PlaygroundResponse|string resp, boolean cache);