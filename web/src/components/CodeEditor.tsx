import * as React from "react";
import MonacoEditor, { ChangeHandler } from 'react-monaco-editor';
import { editor } from 'monaco-editor';

import "./CodeEditor.less"
import { PlaygroundContext } from "./Playground";

const MONACO_OPTIONS: editor.IEditorConstructionOptions = {
    autoIndent: true,
    contextmenu: false,
    renderIndentGuides: false,
    matchBrackets: true,
    automaticLayout: true,
    lineNumbersMinChars: 3,
    scrollBeyondLastLine: false,
    minimap: {
        enabled: false,
    },
    scrollbar: {
        useShadows: true,
    },
    hideCursorInOverviewRuler: true,
    overviewRulerBorder: false,
    overviewRulerLanes: 0,
}

export interface CodeEditorProps {
    onChange: ChangeHandler
}

export function CodeEditor(props: CodeEditorProps) {
    return <PlaygroundContext.Consumer>
            { context => {
                return <div className="code-editor w3-container">
                    <MonacoEditor
                        language="ballerina"
                        value={context.sourceCode}
                        options={MONACO_OPTIONS}
                        onChange={props.onChange}
                    />
                </div>
            }}
        </PlaygroundContext.Consumer>
}