import * as React from "react";
import "./CodeEditor.less"

export class CodeEditor extends React.Component<{}, {}> {
    public render() {
        return <div className="code-editor w3-container">
            <textarea>
                Ballerina Code goes here
            </textarea>
        </div>
    }
}