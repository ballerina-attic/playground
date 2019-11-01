import { editor } from "monaco-editor";
import * as React from "react";
import MonacoEditor, { ChangeHandler } from "react-monaco-editor";

import "./CodeEditor.less";
import { PlaygroundContext } from "./Playground";

const MONACO_OPTIONS: editor.IEditorConstructionOptions = {
    autoIndent: true,
    automaticLayout: true,
    contextmenu: false,
    hideCursorInOverviewRuler: true,
    matchBrackets: true,
    minimap: {
        enabled: false,
    },
    overviewRulerBorder: false,
    overviewRulerLanes: 0,
    renderIndentGuides: false,
    scrollBeyondLastLine: false,
    scrollbar: {
        useShadows: true,
    },
};

export interface CodeEditorProps {
    onChange: ChangeHandler;
}

export function CodeEditor(props: CodeEditorProps) {
    return <PlaygroundContext.Consumer>
            { (context) => {
                return <div className="code-editor w3-container">
                    <MonacoEditor
                        language="ballerina"
                        value={context.sourceCode}
                        options={MONACO_OPTIONS}
                        onChange={props.onChange}
                    />
                </div>;
            }}
        </PlaygroundContext.Consumer>;
}
