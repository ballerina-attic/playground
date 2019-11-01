import * as React from "react";
import "./OutputPanel.less";
import { PlaygroundContext } from "./Playground";

export function OutputPanel() {
    return <PlaygroundContext.Consumer>
        {({ responses }) => (
            <div className="output-panel w3-container">
                {
                    responses.map(({ type, data }) => (
                        <div>
                            {type}: {data}
                        </div>
                    ))
                }
            </div>
        )}
    </PlaygroundContext.Consumer>;
}
