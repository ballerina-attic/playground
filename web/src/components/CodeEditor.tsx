import * as monaco from "monaco-editor";
import * as React from "react";
import MonacoEditor, { ChangeHandler } from "react-monaco-editor";
import * as grammar from "./ballerina.monarch.json";

const BALLERINA_LANG = "ballerina";

monaco.languages.register({ id: BALLERINA_LANG });

interface Tokenizer {
    [name: string]: monaco.languages.IMonarchLanguageRule[];
}

monaco.languages.setMonarchTokensProvider(BALLERINA_LANG, {
    tokenizer: grammar as Tokenizer,
});

import "./CodeEditor.less";
import { PlaygroundContext } from "./Playground";

const MONACO_OPTIONS: monaco.editor.IEditorConstructionOptions = {
    autoIndent: true,
    automaticLayout: true,
    contextmenu: false,
    fontFamily: "\"Lucida Console\", Monaco, monospace",
    fontSize: 12,
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
                        language={BALLERINA_LANG}
                        value={context.sourceCode}
                        options={MONACO_OPTIONS}
                        onChange={props.onChange}
                    />
                </div>;
            }}
        </PlaygroundContext.Consumer>;
}
