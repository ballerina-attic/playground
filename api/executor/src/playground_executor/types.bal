const ExecuteRequest = "Execute";
const StopRequest = "Stop";

type RequestType ExecuteRequest|StopRequest;

type ExecuteData record {
    string sourceCode;
    string balVersion;
};

type RequestData ExecuteData|string|();

type ExecutorRequest record {
    RequestType 'type;
    RequestData data;
};

const ErrorResponse = "Error";
const DataResponse = "Data";
const ControlResponse = "Control";

type ResponseType ErrorResponse|DataResponse|ControlResponse;

type ExecutorResponse record {
    ResponseType 'type;
    RequestData data;
};

type ResponseHandler function(ExecutorResponse resp);