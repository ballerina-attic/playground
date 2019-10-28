import * as React from "react";
import MonacoEditor from 'react-monaco-editor';
import { editor } from 'monaco-editor';

import "./CodeEditor.less"

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


export class CodeEditor extends React.Component<{}, {}> {
    public render() {
        return <div className="code-editor w3-content">
            <MonacoEditor
                language="ballerina"
                value={"Ballerina Code goes here"}
                options={MONACO_OPTIONS}
            />
        </div>
    }
}