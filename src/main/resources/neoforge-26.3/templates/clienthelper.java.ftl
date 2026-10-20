package ${package}.client;

public class ClientHelper {
    public static void openInventory() {
        Minecraft mc = Minecraft.getInstance();
        mc.gui.setScreen(new InventoryScreen(mc.player));
    }
}