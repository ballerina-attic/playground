import * as React from "react";
import "./ControlPanel.less";
import { RunButton } from "./RunButton";
import { ShareButton } from "./ShareButton";

export function ControlPanel() {
    return <div className="control-panel w3-top w3-teal">
                <div className="w3-bar">
                    <img className="logo" src="images/ballerina-logo-play.svg" />
                    <RunButton />
                    <ShareButton />
                </div>
            </div>;
}
