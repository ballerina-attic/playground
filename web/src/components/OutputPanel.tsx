import * as React from "react";
import "./OutputPanel.less";
import { PlaygroundContext } from "./Playground";

export function createLoadingAnimation(text: string) {
    if (text.endsWith("...")) {
    return <span className="loading">{text.replace("...", "")}
        <span>.</span><span>.</span><span>.</span></span>;
    } else {
        return text;
    }
}

export function createHTMLFormattedText(text: string) {
    return text.split(/\n/g).map((val, index, array) => {
        if (index === array.length - 1 && val === "") {
            return;
        }
        const tabbedPieces = val.split(/\t/g);
        return (
            <div>
                {
                    tabbedPieces.length === 1 && <span>{createLoadingAnimation(val)}</span>
                }
                {
                    tabbedPieces.length > 1 &&
                        tabbedPieces
                            .map((tabbedSegment) =>
                                <span>&nbsp;&nbsp;&nbsp;&nbsp;{createLoadingAnimation(tabbedSegment)}</span>,
                            )
                }
            <br/></div>
        );
    });
}

export function getOutputMsg(data: string) {
    let msg = data;
    switch (data) {
        case "Finished Executing.":
            msg = "execution complete."; break;
        case "Compiling Program.":
            msg = "compiling..."; break;
        case "Finished Compiling with errors.":
                    msg = "compilation failed :("; break;
        case "Executing Program.":
                msg = "executing..."; break;
    }
    return msg;
}

export function OutputPanel() {
    return <PlaygroundContext.Consumer>
        {({ responses, waitingOnRemoteServer }) => {
            let inExecutionPhase = false;
            return <div className="output-panel w3-container">
                {waitingOnRemoteServer &&
                <div className="control">{createLoadingAnimation("waiting on remote server...")}</div>}
                {
                    responses.map(({ type, data }, index) => {
                        if (type === "Control" && data === "Finished Compiling.") {
                            return <hr />;
                        }
                        if (type === "Control" && data === "Executing Program.") {
                            inExecutionPhase = true;
                        }
                        if (type === "Control" && (index !== responses.length - 1)) {
                            return;
                        }
                        return (
                            <div className={type.toLowerCase() + " " + (inExecutionPhase ? "output" : "")}>
                                {data === "Finished Executing." && <br/>}
                                {data === "Finished Compiling with errors." && <br/>}
                                {createHTMLFormattedText(getOutputMsg(data))}
                                {data === "Finished Executing." && <div><br/><br/><br/><br/></div>}
                            </div>
                        );
                    })
                }
            </div>;
        }}
    </PlaygroundContext.Consumer>;
}
