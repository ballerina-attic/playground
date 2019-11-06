export type ErrorResponse = "Error";
export type DataResponse = "Data";
export type ControlResponse = "Control";

export type RunRequest = "Run";
export type StopRequest = "Stop";

export interface RunData {
    sourceCode: string;
    balVersion: string;
}

export interface RunnerResponse {
    type: ErrorResponse|DataResponse|ControlResponse;
    data?: string;
}

export interface RunnerRequest {
    type: RunRequest|StopRequest;
    data?: RunData;
}

export class RunSession {

    private websocket: WebSocket;
    private endpoint: string;

    constructor(endpoint: string) {
        if (!endpoint) {
            throw new Error("Invalid Endpoint");
        }
        this.endpoint = endpoint;
    }

    public createConnection(
            onMessage: (resp: RunnerResponse) => void,
            onOpen: (evt: Event) => void,
            onClose: (evt: CloseEvent) => void,
            onError: (evt: Event|Error) => void,
        ) {
        this.websocket = new WebSocket(this.endpoint);
        this.websocket.onmessage = (evt: MessageEvent) => {
            onMessage(JSON.parse(evt.data));
        };
        this.websocket.onopen = onOpen;
        this.websocket.onclose = (evt: CloseEvent) => {
            if (evt.wasClean || evt.code === 1006) {
                onClose(evt);
            } else {
                onError(new Error("Connection Failed."));
            }
        };
        this.websocket.onerror = onError;
    }

    public run(sourceCode: string) {
        this.sendMessage({
            data: {
                balVersion: "1.0.1",
                sourceCode,
            },
            type: "Run",
        });
    }

    public isOpen() {
        return this.websocket && (this.websocket.readyState === WebSocket.OPEN);
    }

    public stop() {
        this.sendMessage({
            type: "Stop",
        });
    }

    public sendMessage(request: RunnerRequest) {
        const { readyState } = this.websocket;
        switch (readyState) {
            case WebSocket.CONNECTING:
                    this.websocket.onopen = () => {
                        this.websocket.send(JSON.stringify(request));
                    };
                    break;
            case WebSocket.OPEN:
                    this.websocket.send(JSON.stringify(request));
                    break;
            default:
                    throw new Error("Unable to send message: " + JSON.stringify(request));
        }
    }

    public close() {
        if (this.websocket.CONNECTING || this.websocket.OPEN) {
            this.websocket.close();
        }
    }
}
