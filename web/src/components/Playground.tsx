import * as React from "react";
import './Playground.less'
import { ControlPanel } from "./ControlPanel";
import { CodeEditor } from "./CodeEditor";
import { OutputPanel } from "./OutputPanel";
import { RunnerResponse, RunSession } from "../utils/runner-client";

export interface PlaygroundProps {};

export interface IPlaygroundContext {
    sourceCode: string;
    runInProgress: boolean;
    showDiagram: boolean;
    responses: Array<RunnerResponse>,
    session: RunSession,
    updateContext: (newContext: Partial<IPlaygroundContext>) => void,
    onRun: () => void
}

export const PlaygroundContext = React.createContext({} as IPlaygroundContext);

export class Playground extends React.Component<PlaygroundProps, IPlaygroundContext> {

    constructor(props: PlaygroundProps) {
        super(props);
        this.state = {
            sourceCode: "",
            runInProgress: false,
            showDiagram: false,
            responses: [],
            session: new RunSession("ws://localhost:9090/runner/run"),
            updateContext: (newContext: Partial<IPlaygroundContext>) => {
                this.setState({
                    ...newContext as IPlaygroundContext
                });
            },
            onRun: this.onRun.bind(this)
        };
    }

    componentDidMount() {
        this.createConnection();
    }

    createConnection() {
        const { session, responses } = this.state;
        if (session) {
            if (!session.isOpen()) {
                session.init(
                    this.onResponse.bind(this),
                    () => {},
                    (evt: CloseEvent) => {
                        alert(evt.reason);
                    },
                    (evt: Event|Error) => {
                        if (evt instanceof Error) {
                            this.setState({
                                responses: [...responses, { type: "Error", data: (evt as Error).message }]
                            }); 
                        } else {
                            this.setState({
                                responses: [...responses, { type: "Error", data: "Unknown Error occurred. " }]
                            }); 
                        }
                    }
                );
            }
        }
    }

    onRun() {
        const { session, sourceCode } = this.state;
        if (session) {
            if (!session.isOpen()) {
                this.createConnection();
            }
        }
        session.run(sourceCode);
    }

    onResponse(resp: RunnerResponse) {
        const { responses } = this.state;
        this.setState({
            responses: [...responses, resp]
        });
    }

    onCodeChange(newCode: string) {
        this.setState({
            sourceCode: newCode
        });
    }

    public render() {
        return <PlaygroundContext.Provider value={this.state}>
                <div className="ballerina-playground">
                    <ControlPanel />
                    <CodeEditor onChange={this.onCodeChange.bind(this)} />
                    <OutputPanel />
                </div>
        </PlaygroundContext.Provider>
    }
}