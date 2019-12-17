export type ErrorResponse = "Error";
export type DataResponse = "Data";
export type ControlResponse = "Control";

export type RunRequest = "Run";
export type StopRequest = "Stop";

export interface RunData {
    sourceCode: string;
    balVersion: string;
}

export interface PlaygroundResponse {
    type: ErrorResponse|DataResponse|ControlResponse;
    data?: string;
}

export interface PlaygroundRequest {
    type: RunRequest|StopRequest;
    data?: RunData;
}

export class PlaySession {

    private websocket: WebSocket;
    private endpoint: string;

    constructor(endpoint: string) {
        if (!endpoint) {
            throw new Error("Invalid Endpoint");
        }
        this.endpoint = endpoint;
    }

    public createConnection(
            onMessage: (resp: PlaygroundResponse) => void,
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

    public sendMessage(request: PlaygroundRequest) {
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

declare const GISTS_API_BACKEND_URL: string;
const gistsApiUrl = GISTS_API_BACKEND_URL === ""
    ? "https://" + window.location.hostname + "/gists"
    : GISTS_API_BACKEND_URL;

export function share(content: string): Promise<Gist> {
    return new Promise((resolve, reject) => {
        const data = {
            content,
            description: "Ballerina Playground",
            fileName: "play.bal",
        };
        const json = JSON.stringify(data);
        const xhr = new XMLHttpRequest();
        xhr.open("POST", gistsApiUrl, true);
        xhr.setRequestHeader("Content-type", "application/json; charset=utf-8");
        xhr.onload = () => {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    resolve(JSON.parse(xhr.responseText) as Gist);
                } else {
                    reject("Error sharing." + xhr.statusText
                        + ", Status Code: " + xhr.status);
                }
            }
        };
        xhr.onerror = (ev) => {
            reject("Error invoking sharing api.");
        };
        xhr.send(json);
    });
}

export function loadGistFile(gistId: string, fileName: string): Promise<GistFile> {
    return new Promise((resolve, reject) => {
        const req = new XMLHttpRequest();
        req.onreadystatechange = function() {
            if (this.readyState === 4) {
                if (this.status === 200) {
                    resolve(JSON.parse(this.responseText) as GistFile);
                } else {
                    reject("Error: " + this.responseText);
                }
            }
        };
        req.open("GET", gistsApiUrl + "/" + gistId + "/" + fileName, true);
        req.send();
    });
}

export interface Gist {
    url: string;
    id: string;
    html_url: string;
    truncated: boolean;
    files: Map<string, GistFile>;
    description: string;
    public: boolean;
    created_at: string;
    updated_at: string;
}

export interface GistFile {
    filename: string;
    type: string;
    language: string;
    raw_url: string;
    size: number;
    truncated: boolean;
    content: string;
}
