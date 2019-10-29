import * as React from "react";
import "./ControlPanel.less"

export class ControlPanel extends React.Component<{}, {}> {
    public render() {
        return <div className="control-panel w3-top w3-teal">
            <div className="w3-bar">
                <button className="w3-button w3-white">Run</button>
                <button className="w3-button w3-white">Diagram</button>
                <button className="w3-button w3-white w3-right">Share</button>
            </div>
        </div>
    }
}