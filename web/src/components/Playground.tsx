import * as React from "react";
import './Playground.less'
import { ControlPanel } from "./ControlPanel";
import { CodeEditor } from "./CodeEditor";
import { OutputPanel } from "./OutputPanel";

export class Playground extends React.Component<{}, {}> {
    public render() {
        return <div className="ballerina-playground">
            <ControlPanel/>
            <CodeEditor />
            <OutputPanel />
        </div>
    }
}