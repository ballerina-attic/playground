package org.ballerinalang.playground.compiler;

import org.ballerinalang.compiler.plugins.AbstractCompilerPlugin;
import org.ballerinalang.model.tree.NodeKind;
import org.ballerinalang.model.tree.PackageNode;
import org.ballerinalang.util.diagnostic.Diagnostic;
import org.ballerinalang.util.diagnostic.DiagnosticLog;

import java.util.stream.Collectors;

public class PlaygroundCompilerPlugin extends AbstractCompilerPlugin {

    private DiagnosticLog diagnosticLog;

    @Override
    public void init(DiagnosticLog diagnosticLog) {
        this.diagnosticLog = diagnosticLog;
    }

    @Override
    public void process(PackageNode packageNode) {
        packageNode.getCompilationUnits()
                .forEach(cu -> {
                    cu.getTopLevelNodes()
                            .stream()
                            .filter(topLevelNode -> topLevelNode.getKind().equals(NodeKind.SERVICE))
                            .collect(Collectors.toList())
                            .forEach(serviceNode -> {
                                diagnosticLog.logDiagnostic(Diagnostic.Kind.ERROR, serviceNode.getPosition(),
                                        "Running Ballerina services is not allowed in playground yet.");
                            });
                });
    }
}