import cn from "classnames";
import * as React from "react";
import { PlaygroundContext } from "./Playground";

export function ShareButton() {
    return <PlaygroundContext.Consumer>
                { ({ onShare, shareInProgress }) => (<button
                        className={cn(
                            "w3-button w3-white w3-round share-button",
                        )}
                        onClick={shareInProgress ? () => undefined : onShare}
                    >
                        {shareInProgress &&
                            <span className="loading">
                                <span>.</span><span>.</span><span>.</span>
                            </span>
                        }
                        {!shareInProgress &&
                            <span>Share</span>
                        }
                </button>)

                }
            </PlaygroundContext.Consumer>;
}
