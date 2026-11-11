package net.nerdypuzzle.inveditor.elements;

import net.mcreator.ui.MCreator;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.workspace.elements.ModElement;
import net.nerdypuzzle.inveditor.parts.gui.InveditGuiEditor;

import java.net.URI;
import java.net.URISyntaxException;
import javax.annotation.Nullable;
import javax.swing.*;
import java.awt.*;

public class InventoryEditGUI extends ModElementGUI<InventoryEdit> {

    private InveditGuiEditor guiEditor;

    public InventoryEditGUI(MCreator mcreator, ModElement modElement, boolean editingMode) {
        super(mcreator, modElement, editingMode);
        guiEditor = new InveditGuiEditor(mcreator);
        this.initGUI();
        super.finalizeGUI();
    }

    protected void initGUI() {
        JPanel guiEditorPanel = new JPanel(new BorderLayout(0, 5));
        guiEditorPanel.setOpaque(false);
        guiEditorPanel.add("Center", guiEditor);
        guiEditorPanel.add("East", guiEditor.sidebar);

        addPage(L10N.t("elementgui.inveditor.gui_editor"), guiEditorPanel);
    }

    public void reloadDataLists() {
        super.reloadDataLists();
    }

    @Override
    protected void openInEditingMode(InventoryEdit invEditor) {
        // Gui editor
        guiEditor.setOpening(true);
        if (invEditor.components != null)
            guiEditor.setComponentList(invEditor.components);
        guiEditor.setSlotComponentsEnabled(true);
        guiEditor.renderBgLayer.setSelected(true);
        guiEditor.getGUITypeSelector().setSelectedIndex(invEditor.type);
        if (invEditor.gridSettings != null) {
            guiEditor.sx.setValue(invEditor.gridSettings.spacingX);
            guiEditor.sy.setValue(invEditor.gridSettings.spacingY);
            guiEditor.ox.setValue(invEditor.gridSettings.offsetX);
            guiEditor.oy.setValue(invEditor.gridSettings.offsetY);
            guiEditor.snapOnGrid.setSelected(invEditor.gridSettings.snapOnGrid);
            if (invEditor.gridSettings.snapOnGrid) {
                guiEditor.editor.showGrid = true;
                guiEditor.editor.repaint();
            }
        }
        guiEditor.setOpening(false);
    }

    public InventoryEdit getElementFromGUI() {
        InventoryEdit invEditor = new InventoryEdit(this.modElement);
        
        // Gui editor
        invEditor.components = guiEditor.getComponentList();
        invEditor.gridSettings.spacingX = (int) guiEditor.sx.getValue();
        invEditor.gridSettings.spacingY = (int) guiEditor.sy.getValue();
        invEditor.gridSettings.offsetX = (int) guiEditor.ox.getValue();
        invEditor.gridSettings.offsetY = (int) guiEditor.oy.getValue();
        invEditor.type = guiEditor.getGUITypeSelector().getSelectedIndex();
        invEditor.gridSettings.snapOnGrid = guiEditor.snapOnGrid.isSelected();

        return invEditor;
    }

    @Override public @Nullable URI contextURL() throws URISyntaxException {
        return null;
    }

}

