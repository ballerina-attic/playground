const CompileRequest = "Compile";
const StopRequest = "Stop";

type RequestType CompileRequest|StopRequest;

type CompileData record {
    string sourceCode;
    string? 'version;
};

type RequestData CompileData|();

type CompilerRequest record {
    RequestType 'type;
    RequestData data;
};

const ErrorResponse = "Error";
const DataResponse = "Data";
const ControlResponse = "Control";

type ResponseType ErrorResponse|DataResponse|ControlResponse;

type CompilerResponse record {
    ResponseType 'type;
    string? data;
};