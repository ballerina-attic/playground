import * as React from "react";
import cn from "classnames";
import { PlaygroundContext } from "./Playground";

export function RunButton() {
    return <PlaygroundContext.Consumer>
                { ({ onRun, runInProgress }) => (<button
                        className={cn(
                            "w3-button w3-white",
                            { "w3-disabled": runInProgress }
                        )}
                        onClick={onRun}
                    >
                        Run
                </button>)

                }
            </PlaygroundContext.Consumer>;
}