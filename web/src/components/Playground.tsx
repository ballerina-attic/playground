import * as React from "react";
import { RunnerResponse, RunSession } from "../utils/runner-client";
import { loadSample } from "../utils/samples";
import { CodeEditor } from "./CodeEditor";
import { ControlPanel } from "./ControlPanel";
import { OutputPanel } from "./OutputPanel";
import "./Playground.less";

declare const RUNNER_BACKEND_URL: string;
const backendUrl = RUNNER_BACKEND_URL;

export interface IPlaygroundState {
    sourceCode: string;
    runInProgress: boolean;
    showDiagram: boolean;
    responses: RunnerResponse[];
    session: RunSession;
}
export interface IPlaygroundContext extends IPlaygroundState {
    updateContext: (newContext: Partial<IPlaygroundContext>) => void;
    onRun: () => void;
}

export const PlaygroundContext = React.createContext({} as IPlaygroundContext);

export class Playground extends React.Component<{}, IPlaygroundState> {

    constructor(props: {}) {
        super(props);
        this.state = {
            responses: [],
            runInProgress: false,
            session: new RunSession(backendUrl),
            showDiagram: false,
            sourceCode: "",
        };
    }

    public componentDidMount() {
        this.createConnection();
        setTimeout(() => {
            loadSample("hello.bal")
                .then(this.onCodeChange.bind(this))
                .catch((error) => {
                    this.printError(error.message);
                });
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

    private onRun() {
        const { session, sourceCode } = this.state;
        if (session) {
            if (!session.isOpen()) {
                this.createConnection();
            }
        }
        // clear console
        this.setState({
            responses: [],
        });
        session.run(sourceCode);
    }

    private onResponse(resp: RunnerResponse) {
        const { responses } = this.state;
        this.setState({
            responses: [...responses, resp],
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
            this.printError("Unknown Error occurred. ");
        }
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
        });
    }
}
