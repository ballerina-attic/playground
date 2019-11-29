import * as clipboard from "clipboard-polyfill";
import * as React from "react";
import { Gist, GistFile, loadGistFile, PlaygroundResponse, PlaySession, share } from "../utils/client";
import { loadSample } from "../utils/samples";
import { CodeEditor } from "./CodeEditor";
import { ControlPanel } from "./ControlPanel";
import { OutputPanel } from "./OutputPanel";
import "./Playground.less";

declare const CONTROLLER_BACKEND_URL: string;
const controllerUrl = CONTROLLER_BACKEND_URL;

export interface IPlaygroundState {
    sourceCode: string;
    runInProgress: boolean;
    shareInProgress: boolean;
    displayCopiedToCB: boolean;
    showDiagram: boolean;
    responses: PlaygroundResponse[];
    session: PlaySession;
    waitingOnRemoteServer: boolean;
}
export interface IPlaygroundContext extends IPlaygroundState {
    updateContext: (newContext: Partial<IPlaygroundContext>) => void;
    onRun: () => void;
    onShare: () => Promise<Gist>;
}

export const PlaygroundContext = React.createContext({} as IPlaygroundContext);

export class Playground extends React.Component<{}, IPlaygroundState> {

    constructor(props: {}) {
        super(props);
        this.state = {
            displayCopiedToCB: false,
            responses: [],
            runInProgress: false,
            session: new PlaySession(controllerUrl),
            shareInProgress: false,
            showDiagram: false,
            sourceCode: "",
            waitingOnRemoteServer: false,
        };
    }

    public componentDidMount() {
        this.createConnection();
        setTimeout(() => {
            const params = new URLSearchParams(location.search);
            const gistId = params.get("gist");
            const fileName = params.get("file");
            if (gistId && fileName) {
                loadGistFile(gistId, fileName)
                    .then((gistFile: GistFile) => {
                        this.onCodeChange(gistFile.content);
                    }, (reason: string) => {
                        this.printError(reason);
                    });
            } else {
                loadSample("hello.bal")
                    .then(this.onCodeChange.bind(this))
                    .catch((error) => {
                        this.printError(error.message);
                    });
            }
        }, 200);
    }

    public render() {
        return <PlaygroundContext.Provider value={this.createContext()}>
                <div className="ballerina-playground">
                    <ControlPanel />
                    <CodeEditor onChange={this.onCodeChange.bind(this)} />
                    <OutputPanel />
                </div>
        </PlaygroundContext.Provider>;
    }

    private createConnection() {
        const { session } = this.state;
        if (session) {
            if (!session.isOpen()) {
                try {
                    session.createConnection(
                        this.onResponse.bind(this),
                        this.onConnectionOpen.bind(this),
                        this.onConnectionClose.bind(this),
                        this.onConnectionError.bind(this),
                    );
                } catch (error) {
                    this.printError(error);
                }
            }
        }
    }

    private onShare() {
        const { sourceCode, shareInProgress } = this.state;
        // prevent parallel sharing
        if (shareInProgress) {
            return;
        }
        this.setState({
            shareInProgress: true,
        });
        // share
        share(sourceCode)
            .then((gist: Gist) => {
                const params = new URLSearchParams(location.search);
                params.set("gist", gist.id);
                params.set("file", "play.bal");
                window.history.replaceState({}, "", `${location.pathname}?${params}`);
                clipboard.writeText("https://play.ballerina.io" + `${location.pathname}?${params}`);
                this.setState({
                    displayCopiedToCB: true,
                    shareInProgress: false,
                });
                setTimeout(() => {
                    this.setState({
                        displayCopiedToCB: false,
                    });
                }, 3000);
            }, (reason: string) => {
                this.printError(reason);
                this.setState({
                    shareInProgress: false,
                });
            });
    }

    private onRun() {
        const { session, sourceCode, runInProgress } = this.state;
        // prevent parallel runs per client
        if (runInProgress) {
            return;
        }
        // clear console and set waiting on remote server.
        this.setState({
            responses: [],
            runInProgress: true,
            waitingOnRemoteServer: true,
        });
        if (session) {
            if (!session.isOpen()) {
                this.createConnection();
            }
        }
        session.run(sourceCode);
    }

    private onResponse(resp: PlaygroundResponse) {
        const { responses } = this.state;
        let runInProgress = true;
        const { type, data } = resp;
        if (type === "Error" ||
            (type === "Control"
                && (data === "Finished Executing."
                    || data === "Finished Compiling with errors."))) {
            runInProgress = false;
        }
        this.setState({
            responses: [...responses, resp],
            runInProgress,
            waitingOnRemoteServer: false,
        });
    }

    private onCodeChange(newCode: string) {
        this.setState({
            sourceCode: newCode,
        });
    }

    private createContext(): IPlaygroundContext {
        return {
            ...this.state,
            onRun: this.onRun.bind(this),
            onShare: this.onShare.bind(this),
            updateContext: (newContext: Partial<IPlaygroundContext>) => {
                this.setState({
                    ...newContext as IPlaygroundContext,
                });
            },
        };
    }

    private onConnectionError(evt: Event|Error) {
        if (evt instanceof Error) {
            this.printError((evt as Error).message);
        } else {
            this.printError("Error connecting to remote server. ");
        }
        this.setState({
            runInProgress: false,
            waitingOnRemoteServer: false,
        });
    }

    private onConnectionOpen(evt: Event) {
        // TODO
    }

    private onConnectionClose(evt: CloseEvent) {
        // TODO
    }

    private printError(msg: string) {
        const { responses } = this.state;
        this.setState({
            responses: [...responses, { type: "Error", data: msg }],
            runInProgress: false,
        });
    }
}
