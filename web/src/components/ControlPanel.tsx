import * as React from "react";
import "./ControlPanel.less";
import { PlaygroundContext } from "./Playground";
import { RunButton } from "./RunButton";
import { ShareButton } from "./ShareButton";

export function ControlPanel() {
    return <PlaygroundContext.Consumer>
    { ({ displayCopiedToCB }) => (
        <React.Fragment>
            <div className="control-panel w3-top w3-teal">
                <div className="w3-bar">
                    <img className="logo" src="images/ballerina-logo-play.svg" />
                    <RunButton />
                    <ShareButton />
                    {displayCopiedToCB &&
                        <span
                            className="w3-text w3-small w3-animate-opacity w3-hide-small">
                                copied to clipboard.
                        </span>
                    }
                    {displayCopiedToCB &&
                        <span
                            className="w3-text w3-small w3-animate-opacity w3-hide-medium w3-hide-large">
                                copied.
                        </span>
                    }
                    <span className="w3-text w3-right download-text w3-hide-small">Love it? <a
                        target="_blank"
                        href="https://ballerina.io/downloads/">
                                download now</a>!
                        </span>
                </div>
            </div>
            <div className="control-panel w3-bottom">
                <div className="w3-bar">
                    <RunButton />
                </div>
            </div>
        </React.Fragment>
        )}
    </PlaygroundContext.Consumer>;
}
