import * as React from "react";
import { Playground } from "../../src/components/Playground";
import "./Playground.less";

export const EmbeddedPlayground = () => (

    <div className="embedded">
        <Playground embedded={true} />
    </div>
    );
