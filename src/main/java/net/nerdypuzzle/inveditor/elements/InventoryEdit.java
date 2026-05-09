package net.nerdypuzzle.inveditor.elements;

import net.mcreator.element.GeneratableElement;
import net.mcreator.element.parts.GridSettings;
import net.mcreator.element.parts.gui.Button;
import net.mcreator.element.parts.gui.GUIComponent;
import net.mcreator.element.parts.gui.ImageButton;
import net.mcreator.element.types.interfaces.IGUI;
import net.mcreator.ui.workspace.resources.TextureType;
import net.mcreator.workspace.elements.ModElement;
import net.mcreator.workspace.references.ModElementReference;
import net.mcreator.workspace.references.TextureReference;
import net.nerdypuzzle.inveditor.parts.gui.InveditGui;

import java.lang.module.ModuleDescriptor;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class InventoryEdit extends GeneratableElement implements IGUI {
    public List<String> mixins =  ModuleDescriptor.Version.parse(getModElement().getGeneratorConfiguration().getGeneratorMinecraftVersion())
            .compareTo(ModuleDescriptor.Version.parse("1.21.3")) >= 0 ? List.of("WidgetInvoker", "RecipeBookAccessor") : Collections.singletonList("WidgetInvoker");

    // Gui editor
    @ModElementReference
    @TextureReference(TextureType.SCREEN) public List<GUIComponent> components;

    public GridSettings gridSettings;

    public final transient int W;
    public final transient int H;

    public int type;


    public InventoryEdit(ModElement element) {
        super(element);
        this.W = InveditGui.W;
        this.H = InveditGui.H;
        this.gridSettings = new GridSettings();
        this.components = new ArrayList<>();

        this.type = 0;
    }

    @Override public List<GUIComponent> getComponents() {
        return components;
    }

    public boolean hasButtonEvents() {
        for (GUIComponent component : components) {
            if (component instanceof Button button) {
                if (button.onClick != null && button.onClick.getName() != null)
                    return true;
            } else if (component instanceof ImageButton imageButton) {
                if (imageButton.onClick != null && imageButton.onClick.getName() != null)
                    return true;
            }
        }
        return false;
    }

}

