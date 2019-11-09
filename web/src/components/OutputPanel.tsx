import * as React from "react";
import "./OutputPanel.less";
import { PlaygroundContext } from "./Playground";

export function createHTMLFormattedText(text: string) {
    return text.split(/\n/g).map((val) => {
        const tabbedPieces = val.split(/\t/g);
        return (
            <div>
                {
                    tabbedPieces.length === 1 && <span>{val}</span>
                }
                {
                    tabbedPieces.length > 1 &&
                        tabbedPieces
                            .map((tabbedSegment) =>
                                <span>&nbsp;&nbsp;&nbsp;&nbsp;{tabbedSegment}</span>,
                            )
                }
            <br/></div>
        );
    });
}

export function OutputPanel() {
    return <PlaygroundContext.Consumer>
        {({ responses, waitingOnRemoteServer }) => (
            <div className="output-panel w3-container">
                {waitingOnRemoteServer && <div className="control">Waiting on remote server</div>}
                {
                    responses.map(({ type, data }, index) => {
                        if (type === "Control" && (index !== responses.length - 1)) {
                            return <span />;
                        }
                        return (
                            <div className={type.toLowerCase()}>
                                {createHTMLFormattedText(data)}
                            </div>
                        );
                    })
                }
            </div>
        )}
    </PlaygroundContext.Consumer>;
}
