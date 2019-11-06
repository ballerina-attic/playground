import * as React from "react";
import "./OutputPanel.less";
import { PlaygroundContext } from "./Playground";

export function OutputPanel() {
    return <PlaygroundContext.Consumer>
        {({ responses, waitingOnRemoteServer }) => (
            <div className="output-panel w3-container">
                {waitingOnRemoteServer && <div className="control">Waiting on remote server</div>}
                {
                    responses.map(({ type, data }) => (
                        <div className={type.toLowerCase()}>
                           {data.split(/\n/g).map((val) => {
                                const tabbedPieces = val.split(/\t/g);
                                return (
                                    <div>
                                        {
                                            tabbedPieces.length === 1 && <span>{val}</span>
                                        }
                                        {
                                            tabbedPieces.length > 1 &&
                                                val.split(/\t/g)
                                                    .map((tabbedSegment) =>
                                                        <span>&nbsp;&nbsp;&nbsp;&nbsp;{tabbedSegment}</span>,
                                                    )
                                        }
                                    <br/></div>
                                );
                            })}
                        </div>
                    ))
                }
            </div>
        )}
    </PlaygroundContext.Consumer>;
}
