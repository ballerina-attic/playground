export type ErrorResponse = "Error";
export type DataResponse = "Data";
export type ControlResponse = "Control";

export type RunRequest = "Run";
export type StopRequest = "Stop";

export interface RunData {
    sourceCode: string;
    version?: string;
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

    websocket: WebSocket;
    endpoint: string;

    constructor(endpoint: string) {
        
        if (!endpoint) {
            throw new Error('Invalid Endpoint');
        }
        this.endpoint = endpoint;
    }

    init(
            onMessage: (resp: RunnerResponse) => void = () => {}, 
            onOpen: (evt: Event) => void = () => {},
            onClose: (evt: CloseEvent) => void = () => {}, 
            onError: (evt: Event|Error) => void = () => {},
        ) {
        this.websocket = new WebSocket(this.endpoint);
        this.websocket.onmessage = (evt: MessageEvent) => { 
            onMessage(JSON.parse(evt.data)); 
        };
        this.websocket.onopen = onOpen;
        this.websocket.onclose = (evt: CloseEvent) => {
            if (evt.wasClean) {
                onClose(evt);
            } else {
                onError(new Error("Connection Failed."));
            }
        }
        this.websocket.onerror = onError;
    }

    run(sourceCode: string) {
        this.sendMessage({
            type: "Run",
            data: {
                sourceCode,
                version: "1.0.1"
            }
        });
    }

    isOpen() {
        return this.websocket && (this.websocket.readyState == WebSocket.OPEN);
    }

    stop() {
        this.sendMessage({
            type: 'Stop',
        });
    }

    sendMessage(request: RunnerRequest) {
        const { readyState } = this.websocket;
        switch (readyState) {
            case WebSocket.CONNECTING:
                    this.websocket.onopen = () => {
                        this.websocket.send(JSON.stringify(request));
                    }
                    break;
            case WebSocket.OPEN:     
                    this.websocket.send(JSON.stringify(request));
                    break;
            default:
                    throw new Error('Unable to send message: ' + JSON.stringify(request));
        }
    }

    close() {
        if (this.websocket.CONNECTING || this.websocket.OPEN) {
            this.websocket.close();
        }
    }
}