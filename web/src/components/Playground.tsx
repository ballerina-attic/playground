import * as React from "react";
import { RunnerResponse, RunSession } from "../utils/runner-client";
import { CodeEditor } from "./CodeEditor";
import { ControlPanel } from "./ControlPanel";
import { OutputPanel } from "./OutputPanel";
import "./Playground.less";

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
            session: new RunSession("ws://localhost:9090/runner/run"),
            showDiagram: false,
            sourceCode: "",
        };
    }

    public componentDidMount() {
        this.createConnection();
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
                session.createConnection(
                    this.onResponse.bind(this),
                    this.onConnectionOpen.bind(this),
                    this.onConnectionClose.bind(this),
                    this.onConnectionError.bind(this),
                );
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
        const { responses } = this.state;
        if (evt instanceof Error) {
            this.setState({
                responses: [...responses, { type: "Error", data: (evt as Error).message }],
            });
        } else {
            this.setState({
                responses: [...responses, { type: "Error", data: "Unknown Error occurred. " }],
            });
        }
    }

    private onConnectionOpen(evt: Event) {
        // TODO
    }

    private onConnectionClose(evt: CloseEvent) {
        // TODO
    }
}
