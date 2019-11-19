import * as React from "react";
import "./ControlPanel.less";
import { PlaygroundContext } from "./Playground";
import { RunButton } from "./RunButton";
import { ShareButton } from "./ShareButton";

export function ControlPanel() {
    return <PlaygroundContext.Consumer>
    { ({ displayCopiedToCB }) => (
        <div className="control-panel w3-top w3-teal">
            <div className="w3-bar">
                <img className="logo" src="images/ballerina-logo-play.svg" />
                <RunButton />
                <ShareButton />
                {displayCopiedToCB &&
                    <span
                        className="w3-text w3-small w3-animate-opacity">
                            copied to clipboard.
                    </span>
                }
            </div>
        </div>)}
    </PlaygroundContext.Consumer>;
}
