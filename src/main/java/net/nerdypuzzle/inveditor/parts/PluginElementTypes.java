package net.nerdypuzzle.inveditor.parts;

import net.mcreator.element.ModElementType;
import net.nerdypuzzle.inveditor.elements.*;

import static net.mcreator.element.ModElementTypeLoader.register;

public class PluginElementTypes {
    public static ModElementType<?> INVEDIT;

    public static void load() {

        INVEDIT = register(
                new ModElementType<>("invedit", (Character) 'I', InventoryEditGUI::new, InventoryEdit.class)
        );

    }

}