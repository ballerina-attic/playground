import * as React from "react";
import "./OutputPanel.less"

export class OutputPanel extends React.Component<{}, {}> {
    public render() {
        return <div className="output-panel w3-content">
            <code>
                Console output
            </code>
        </div>
    }
}