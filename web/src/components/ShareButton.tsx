import cn from "classnames";
import * as React from "react";
import { PlaygroundContext } from "./Playground";

export function ShareButton() {
    return <PlaygroundContext.Consumer>
                { ({ onShare, shareInProgress }) => (<button
                        className={cn(
                            "w3-button w3-white w3-round",
                            { "w3-disabled": shareInProgress },
                        )}
                        onClick={onShare}
                    >
                        Share
                        {shareInProgress &&
                            <span className="loading">
                                <span>.</span><span>.</span><span>.</span>
                            </span>
                        }
                </button>)

                }
            </PlaygroundContext.Consumer>;
}
