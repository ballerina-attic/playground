import * as React from "react";
import MonacoEditor, { ChangeHandler } from "react-monaco-editor";
import * as grammar from "./ballerina.monarch.json";

const BALLERINA_LANG = "ballerina";

import "./CodeEditor.less";
import { PlaygroundContext } from "./Playground";

const MONACO_OPTIONS = {
    autoIndent: true,
    automaticLayout: true,
    contextmenu: false,
    fontFamily: "\"Lucida Console\", Monaco, monospace",
    fontSize: 13,
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
                        editorDidMount={(editor, { languages }) => {
                            languages.register({ id: BALLERINA_LANG });
                            languages.setMonarchTokensProvider(BALLERINA_LANG, {
                                tokenizer: grammar as any,
                            });

                        }}
                    />
                </div>;
            }}
        </PlaygroundContext.Consumer>;
}
