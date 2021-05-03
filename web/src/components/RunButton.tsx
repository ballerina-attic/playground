import cn from "classnames";
import * as React from "react";
import { PlaygroundContext } from "./Playground";

export function RunButton() {
    return <PlaygroundContext.Consumer>
                { ({ onRun, runInProgress, embedded }) => (<button
                        className={cn(
                            "w3-button w3-white run-button",
                            { "w3-round": !embedded},
                        )}
                        onClick={runInProgress ? () => undefined : onRun}
                    >
                        {runInProgress &&
                            <span className="loading">
                                <span>.</span><span>.</span><span>.</span>
                            </span>
                        }
                        {!runInProgress &&
                            <span>Run</span>
                        }
                        {embedded && !runInProgress &&
                            <i className="fa fa-play-circle-o fa-lg" />}
                </button>)

                }
            </PlaygroundContext.Consumer>;
}
