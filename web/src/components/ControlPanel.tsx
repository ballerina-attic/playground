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
                            copied to<br/>clipboard.
                    </span>
                }
                <span className="w3-text w3-right download-text w3-hide-small">Love it? <a
                    target="_blank"
                    href="https://ballerina.io/downloads/">
                            download now</a>!
                    </span>
            </div>
        </div>)}
    </PlaygroundContext.Consumer>;
}
