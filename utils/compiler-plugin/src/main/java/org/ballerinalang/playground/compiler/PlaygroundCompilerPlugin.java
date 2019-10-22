package org.ballerinalang.playground.compiler;


import org.ballerinalang.compiler.plugins.AbstractCompilerPlugin;
import org.ballerinalang.model.tree.AnnotationAttachmentNode;
import org.ballerinalang.model.tree.ServiceNode;
import org.ballerinalang.util.diagnostic.DiagnosticLog;

import java.util.List;

public class PlaygroundCompilerPlugin extends AbstractCompilerPlugin {


    @Override
    public void init(DiagnosticLog diagnosticLog) {

    }

    @Override
    public void process(ServiceNode serviceNode, List<AnnotationAttachmentNode> annotations) {
        if (serviceNode != null) {
            throw new RuntimeException("Running services in playground is not allowed.");
        }
    }
}